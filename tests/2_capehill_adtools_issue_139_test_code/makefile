PROG:=main$(INFIX)_test_2.exe
CC?=gcc
AR?=ar
RANLIB?=ranlib
ifeq ($(NO_DYN),)
LIB:=libf.so
else
LIB:=libf.a
endif
RELO=lib.o

LDFLAGS+=-L. -lf 

all: $(PROG)
$(PROG): main.c $(LIB)
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
	@echo "####################"
	@echo "####################"
	@echo "####################"
	@echo "Expected output when invoking \"test_dyn\", \"test_static\": "
	@echo "--------------------"
	@echo "ctor"
	@echo "ctor2"
	@echo "function 123"
	@echo "main result 123"
	@echo "dtor2"
	@echo "dtor"
	@echo "--------------------"
	@echo "####################"
	@echo "####################"
	@echo "####################"

$(LIB): $(RELO)
ifeq ($(NO_DYN),)
	$(CC) $(CFLAGS) -o libf.so lib.o -shared
else
	$(AR) cruv  libf.a lib.o
	$(RANLIB) libf.a
endif

$(RELO): lib.c
	$(CC) $(CFLAGS) -o lib.o -c lib.c -fPIC

.PHONY: clean
clean:
	@-rm *.o *.exe log*.txt *.so *.a
