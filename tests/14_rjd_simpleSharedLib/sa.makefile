PROG=main
SO=libsharedObj.so

C_LIB?=clib4
CC=ppc-amigaos-gcc
CFLAGS=-Wall -Wextra -pedantic -v -Wl,--verbose -mcrt=$(C_LIB)
LDFLAGS=-use-dynld  -L. -athread=native
LDLIBS=-l$(patsubst lib%.so,%,$(SO)) -lpthread

all: $(PROG)

$(PROG): $(PROG).o $(SO)
	$(CC) -o $(PROG) $< $(LDFLAGS) $(LDLIBS) $(CFLAGS)

$(PROG).o: main.c
	$(CC) -c -o $@ $< $(CFLAGS)

$(SO): $(patsubst lib%.so,%.o,$(SO))
	$(CC) -shared -o $@ $< $(CFLAGS)

$(patsubst lib%.so,%.o,$(SO)): $(patsubst lib%.so,%.c,$(SO))
	$(CC) -c -o $@ $< -fPIC $(CFLAGS)

.PHONY: clean
clean:
	-rm -f main main.o sharedObj.o libsharedObj.so
