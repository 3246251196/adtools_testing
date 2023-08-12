#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <dos/dos.h>
#include <exec/exec.h>
#include <exec/types.h>

#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/utility.h>

struct magicwordinfo
{
	ULONG magicword;
	void (*func)(void);
};

struct Library *DOSBase = NULL;
struct DOSIFace *IDOS = NULL;

// use __UtilityBase because this is required for clib2 initialization --> see clib2/stdlib_lib_main.c
struct Library *__UtilityBase = NULL;
struct UtilityIFace *__IUtility = NULL;

void _start(void)
{
}

static BOOL InitClib2(void);
static void UnInitClib2(void);

int initamigastuff(void)
{
	SysBase = *((struct ExecBase **) 4);
	IExec = (struct ExecIFace *) ((struct ExecBase *) SysBase)->MainInterface;

 	DOSBase = OpenLibrary("dos.library", 0);
	IDOS = (struct DOSIFace *) GetInterface(DOSBase, "main", 1, NULL);

	if(!InitClib2()) return 0;

	return 1;
}

void freeamigastuff(void)
{
	UnInitClib2();

	if(IDOS) DropInterface((struct Interface *) IDOS);
	if(DOSBase) CloseLibrary((struct Library *) DOSBase);
}

void func(void)
{
	BPTR fh;

	initamigastuff();

	fh = Open("CON:100/100/320/240/Output/AUTO/CLOSE/WAIT", MODE_NEWFILE);
	FPrintf(fh, "Hello from child!\n");
	FFlush(fh);

	freeamigastuff();
}

const struct magicwordinfo magicword = {
	0xC0DEFACE,
	func
};

// NB: this has been taken from clib2/stdlib_lib_main.c --> normally, it wouldn't be
// necessary to copy this code here but we could just call __lib_init() and __lib_exit()
// exported by clib2 but we can't do this here because __lib_init() and __lib_exit()
// are only available in clib2-ts and this isn't included in the latest SDK any more
// so we have to work around the problem by copying the code from clib2 directly

#include <setjmp.h>

extern jmp_buf __exit_jmp_buf;
extern BOOL __exit_blocked;

/****************************************************************************/

/*
 * Dummy constructor and destructor array. The linker script will put these at the
 * very beginning of section ".ctors" and ".dtors". crtend.o contains a similar entry
 * with a NULL pointer entry and is put at the end of the sections. This way, the init
 * code can find the global constructor/destructor pointers.
 *
 * WARNING:
 * This hack does not work correctly with GCC 5 and higher. The optimizer
 * will see a one element array and act appropriately. The current workaround
 * is to use -fno-aggressive-loop-optimizations when compiling this file.
 */
static void (*__CTOR_LIST__[1]) (void) __attribute__(( used, section(".ctors"), aligned(sizeof(void (*)(void))) ));
static void (*__DTOR_LIST__[1]) (void) __attribute__(( used, section(".dtors"), aligned(sizeof(void (*)(void))) ));

/****************************************************************************/

/****************************************************************************/

static void
_init(void)
{
	int num_ctors,i;
	int j;

	for(i = 1, num_ctors = 0 ; __CTOR_LIST__[i] != NULL ; i++)
		num_ctors++;

	for(j = 0 ; j < num_ctors ; j++)
		__CTOR_LIST__[num_ctors - j]();
}

/****************************************************************************/

static void
_fini(void)
{
	int num_dtors,i;
	static int j;

	for(i = 1, num_dtors = 0 ; __DTOR_LIST__[i] != NULL ; i++)
		num_dtors++;

	while(j++ < num_dtors)
		__DTOR_LIST__[j]();
}

STATIC BOOL lib_init_successful;

/****************************************************************************/

STATIC BOOL
open_libraries(void)
{
	BOOL success = FALSE;
	int os_version;

	/* Check which minimum operating system version we actually require. */
	os_version = 37;

	__UtilityBase = OpenLibrary("utility.library",os_version);
	if(__UtilityBase == NULL)
		goto out;

	#if defined(__amigaos4__)
	{
		__IUtility = (struct UtilityIFace *)GetInterface(__UtilityBase, "main", 1, 0);
		if(__IUtility == NULL)
			goto out;
	}
	#endif /* __amigaos4__ */

	success = TRUE;

 out:

	return(success);
}

/****************************************************************************/

STATIC VOID
close_libraries(VOID)
{
	#if defined(__amigaos4__)
	{
		if(__IUtility != NULL)
		{
			DropInterface((struct Interface *)__IUtility);
			__IUtility = NULL;
		}
 	}
	#endif /* __amigaos4__ */

	if(__UtilityBase != NULL)
	{
		CloseLibrary(__UtilityBase);
		__UtilityBase = NULL;
	}
}

/****************************************************************************/

static void UnInitClib2(void)
{
	if(lib_init_successful)
	{
		/* Enable exit() again. */
		__exit_blocked = FALSE;

		/* If one of the destructors drops into exit(), either directly
		   or through a failed assert() call, processing will resume with
		   the next following destructor. */
		(void)setjmp(__exit_jmp_buf);

		/* Go through the destructor list */
		_fini();

		close_libraries();

		lib_init_successful = FALSE;
	}
}

/****************************************************************************/

static BOOL InitClib2(void)
{
	int result = FALSE;

	/* Open dos.library and utility.library. */
	if(!open_libraries())
		goto out;

	/* This plants the return buffer for _exit(). */
	if(setjmp(__exit_jmp_buf) != 0)
	{
		/* If one of the destructors drops into exit(), either directly
		   or through a failed assert() call, processing will resume with
		   the next following destructor. */
		(void)setjmp(__exit_jmp_buf);

		/* Go through the destructor list */
		_fini();

		goto out;
	}

	/* Go through the constructor list */
	_init();

	/* Disable exit() and its kin. */
	__exit_blocked = TRUE;

	/* Remember this so that __lib_exit() will know what to do. */
	lib_init_successful = TRUE;

	result = TRUE;

 out:

	if(!lib_init_successful)
		close_libraries();

	return(result);
}
