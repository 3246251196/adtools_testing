#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <exec/exec.h>
#include <exec/types.h>

#include <proto/elf.h>
#include <proto/exec.h>

struct magicwordinfo
{
	ULONG magicword;
	void (*func)(void);
};

struct Library *ElfBase = NULL;
struct ElfIFace *IElf = NULL;

static int findmagicword(UBYTE *data, int size)
{
	int i;

	for(i = 0; i <= size - sizeof(struct magicwordinfo); i += 2) {

		struct magicwordinfo *tmp = (struct magicwordinfo *) (data + i);

		if(tmp->magicword == 0xC0DEFACE) {
			tmp->func();
			return 1;
		}
	}

	return 0;
}

int main(int argc, char *argv[])
{
	APTR obj;
	int k, c = 0;

	ElfBase = OpenLibrary("elf.library", 0);
	IElf = (struct ElfIFace *) GetInterface(ElfBase, "main", 1, NULL);

	obj = OpenElfTags(OET_Filename, "child", TAG_DONE);
	ElfLoadSegTags(obj, ELS_FreeUnneeded, TRUE, TAG_DONE);
	GetElfAttrsTags(obj, EAT_NumSections, &c, TAG_DONE);

	for(k = 0; k < c; k++) {

		APTR s = GetSectionTags(obj, GST_SectionIndex, k, TAG_DONE);
		Elf32_Shdr *h = GetSectionHeaderTags(obj, GST_SectionIndex, k, TAG_DONE);

		if(s && h && h->sh_size > sizeof(struct magicwordinfo)) {
			if(findmagicword(s, h->sh_size)) break;
		}
	}

	CloseElfTags(obj, CET_UnloadSeg, TRUE, TAG_DONE);

	DropInterface((struct Interface *) IElf);
	CloseLibrary((struct Library *) ElfBase);

	return 0;
}
