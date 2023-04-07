include ../common.mak

RELO:=lib.o
ifneq ($(DYN),)
LIB:=libf.so
else
LIB:=libf.a
endif

CFLAGS+=-Wall -Werror -pedantic -std=c11 -fPIC
LDFLAGS+=-L. -lf -athread=native

$(PROG): main.c $(LIB)
	$(call LOG_RUN,Link,$(CC) -o $@ $< $(LDFLAGS))
	$(call LOG_RUN,Readelf,$(READELF) -d $(PROG))

$(LIB): $(RELO)
ifneq ($(DYN),)
	$(call LOG_RUN,Creating Shared Object,$(CC) $(CFLAGS) -o libf.so lib.o -shared)
else
	$(call LOG_RUN,Creating Static Library,$(AR) cruv $(LIB) $(RELO))
	$(call LOG_RUN,ranlib,$(RANLIB) $(LIB))
endif

$(RELO): lib.c
	$(call LOG_RUN,Compile Library Relocatable -fPIC,$(CC) $(CFLAGS) -o $(RELO) -c $<)

#@ ctor
#@ ctor2
#@ function 123
#@ main result 123
#@ dtor2
#@ dtor
