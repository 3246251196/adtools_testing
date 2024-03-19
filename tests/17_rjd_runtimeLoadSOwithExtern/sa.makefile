ifeq ($(V),1)
VERBOSE:=-v -Wl,--verbose
endif

ifeq ($(shell uname),AmigaOS)
CC=ppc-amigaos-gcc
CFLAGS=-mcrt=clib4
LDFLAGS=-use-dynld
AOS4_THREADING=-athread=native
endif

CFLAGS+=-Wall -Wextra $(VERBOSE)

.PHONY: all
all: main

main: main.o librelo.so libextern.so
	$(CC) $(CFLAGS) -o  $@ $< $(LDFLAGS) $(AOS4_THREADING)

main.o: main.c
	$(CC) $(CFLAGS) -c -o $@ $<
relo.o: relo.c
	$(CC) $(CFLAGS) -c -o $@ $< -fPIC

librelo.so: relo.o
	$(CC) $(CFLAGS) -shared -o $@ $<
libextern.so: extern.o
	$(CC) $(CFLAGS) -shared -o $@ $<

extern.o: extern.c
clean:
	-rm *.o *.so main
