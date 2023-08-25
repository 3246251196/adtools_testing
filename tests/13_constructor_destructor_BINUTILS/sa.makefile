ifneq ($(shell uname),AmigaOS)
CC=ppc-amigaos-gcc
else
CC=gcc
endif

CPPFLAGS+=-D__USE_INLINE__

loader: loader.c child
	$(CC) $(CPPFLAGS) -o $@ $<

child: child.c
	$(CC) $(CPPFLAGS) -nostartfiles -o $@ $^

