CRT=newlib
CC=ppc-amigaos-gcc -mcrt=$(CRT)
PROG:=tls

$(PROG): tls.o
#	$(CC) -S -o $@.S $(PROG).c
	$(CC) -o $@ $< -lpthread -athread=native

.PHONY= clean
clean:
	-rm -f *.o *.S $(PROG)
