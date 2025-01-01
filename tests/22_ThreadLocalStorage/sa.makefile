CRT=clib4
CC=ppc-amigaos-gcc -mcrt=$(CRT)
PROG:=tls
CPPFLAGS=-DLARGE -DTHREAD

$(PROG): tls.o
#	$(CC) -S -o $@.S $(PROG).c
	$(CC) -o $(CPPFLAGS) $@ $< -lpthread -athread=native

.PHONY= clean
clean:
	-rm -f *.o *.S $(PROG)
