include ../common.mak

# This test is just for clib4 dynamic
ifneq ($(C_LIB),clib4)
$(eval $(call DUMMY_TEST))
else
ifeq ($(DYN),)
$(eval $(call DUMMY_TEST))
else

EXTRA_FILES+=librelo.so

THREAD_IMPL=native
CFLAGS+=-athread=$(THREAD_IMPL)

$(PROG): main.c librelo.so extern.o
# Not linked here, the function will be loaded at runtime
	$(call LOG_CMD,Link,$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS))

librelo.so: relo.o
	$(call LOG_CMD,Create Shared Object,$(CC) $(CFLAGS) -shared -o $@ $<)

relo.o: relo.c
	$(call LOG_CMD,Create Relocatable Object,$(CC) $(CFLAGS) -c -fPIC -o $@ $<)

endif
endif

#@ Answer: 84
