include ../common.mak

SO=libsharedObj.so

CFLAGS+=-Wall -Wextra -pedantic
THREAD_IMPL?=native
LDFLAGS+=-L. -athread=$(THREAD_IMPL)
LDLIBS=-l$(patsubst lib%.so,%,$(SO)) -lpthread

$(PROG): $(PROG).o $(SO)
	$(call LOG_CMD,Link,$(CC) -o $(PROG) $< $(LDFLAGS) $(LDLIBS))

$(PROG).o: main.c
	$(call LOG_CMD,Compile Relocatable Object,$(CC) -c -o $@ $< $(CFLAGS))

$(SO): $(patsubst lib%.so,%.o,$(SO))
	$(call LOG_CMD,Creating Shared Object,$(CC) -shared -o $@ $<)

$(patsubst lib%.so,%.o,$(SO)): $(patsubst lib%.so,%.c,$(SO))
	$(call LOG_CMD,Creating FPIC object,$(CC) -c -o $@ $< -fPIC $(CFLAGS))
