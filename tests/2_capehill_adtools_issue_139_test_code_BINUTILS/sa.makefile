ifneq ($(shell uname),AmigaOS)
CC=ppc-amigaos-gcc
else
CC=gcc
endif

PROGS=main_dynamic main_static
CFLAGS+=-Wall -Werror -pedantic -std=c11

.PHONY: all clean
all: $(PROGS)

main_dynamic: main.c libf.so
	$(CC) $(CFLAGS) -o $@ $^ -use-dynld -athread=native

main_static: main.c libf.a
	$(CC) $(CFLAGS) -o $@ $^

libf.so: lib.o
	$(CC) $(CFLAGS) -o $@ $< -shared

libf.a: lib.o
	ar cruv $@ $<

lib.o: lib.c
	$(CC) $(CFLAGS) -fPIC -c -o $@ $<

clean:
	-rm -f *.so *.a *.o $(PROGS)
