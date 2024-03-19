ifeq ($(V),1)
VERBOSE:=-v -Wl,--verbose
endif

CC=ppc-amigaos-gcc
CFLAGS=-mcrt=clib4 -Wall -Wextra $(VERBOSE)
LDFLAGS=-use-dynld
.PHONY: all
all: main

main: main.o librelo.so extern.o
	$(CC) $(CFLAGS) -o  $@ $< $(LDFLAGS) -athread=native

main.o: main.c
	$(CC) $(CFLAGS) -c -o $@ $<

relo.o: relo.c
	$(CC) $(CFLAGS) -c -o $@ $< -fPIC

librelo.so: relo.o
	$(CC) $(CFLAGS) -shared -o $@ $<

extern.o: extern.c

clean:
	-rm *.o *.so main
