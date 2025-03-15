include ../common.mak

CFLAGS+=-Wall -Wextra -pedantic
THREAD_IMPL?=native
LDFLAGS+=-L. -athread=$(THREAD_IMPL)
LDLIBS=-lsharedObj

$(PROG): $(PROG).o libsharedObj.so
	$(call LOG_CMD,Link,$(CC) -o $(PROG) $< $(LDFLAGS) $(LDLIBS))

$(PROG).o: main.c
	$(call LOG_CMD,Compile Relocatable Object,$(CC) -c -o $@ $< $(CFLAGS))

sharedObj.c: sharedObj.h

libsharedObj.so: sharedObj.o
	$(call LOG_CMD,Creating Shared Object,$(CC) $(CFLAGS) -shared -o $@ $<)

sharedObj.o: sharedObj.c
	$(call LOG_CMD,Creating FPIC object,$(CC) -c -o $@ $< -fPIC $(CFLAGS))

#@ Inside Shared Object function: fn()
