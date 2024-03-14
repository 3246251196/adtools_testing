include ../common.mak

# This is a clib4 test
ifeq ($(C_LIB),clib4)
SO=libsharedObj.so

EXTRA_FILES+=$(SO)

CFLAGS+=-Wall -Wextra -pedantic
THREAD_IMPL?=native
LDFLAGS+=-L. -athread=$(THREAD_IMPL)
LDLIBS=-l$(patsubst lib%.so,%,$(SO)) -lpthread

$(PROG): $(PROG).o $(SO)
	$(call LOG_CMD,Link,$(CC) -o $(PROG) $< $(LDFLAGS) $(LDLIBS))

$(PROG).o: main.c
	$(call LOG_CMD,Compile Relocatable Object,$(CC) -c -o $@ $< $(CFLAGS))

$(SO): $(patsubst lib%.so,%.o,$(SO))
	$(call LOG_CMD,Creating Shared Object,$(CC) $(CFLAGS) -shared -o $@ $<)

$(patsubst lib%.so,%.o,$(SO)): $(patsubst lib%.so,%.c,$(SO))
	$(call LOG_CMD,Creating FPIC object,$(CC) -c -o $@ $< -fPIC $(CFLAGS))
else
$(eval $(call DUMMY_TEST))
endif

#@ Count: 100000000
