CC=ppc-amigaos-gcc
CFLAGS=-mcrt=clib4 -Wall -Wextra
.PHONY: all
all: main

main: main.o librelo.so
	$(CC) $(CFLAGS) -use-dynld -o $@ $<

main.o: main.c
	$(CC) $(CFLAGS) -c -o $@ $<

relo.o: relo.c
	$(CC) $(CFLAGS) -c -o $@ $< -fPIC

librelo.so: relo.o
	$(CC) $(CFLAGS) -shared -o $@ $<

clean:
	-rm *.o *.so main
