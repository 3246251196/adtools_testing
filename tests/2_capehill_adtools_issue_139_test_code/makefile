ifeq ($(shell uname),AmigaOS)
CC:=gcc
else
ifneq ($(shell uname), Linux)
$(error Unexpected platform)
else
CC:=ppc-amigaos-gcc
ifneq ($(shell which $(CC) 1>/dev/null 2>&1 ; echo $$?), 0)
$(error $(CC) was not found on your path)
endif
endif
endif

all:
	$(CC) -o lib.o -c lib.c -fPIC
	$(CC) -o libf.so lib.o -shared
	ar cruv  libf.a lib.o
	ranlib libf.a
	$(CC) -o test_dyn main.c -use-dynld -L. -lf -athread=native
	$(CC) -o test_static main.c -L. -lf -athread=native
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
