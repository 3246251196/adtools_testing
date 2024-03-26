include ../common.mak

# This test is just for clib4 dynamic
ifneq ($(C_LIB),clib4)
$(eval $(call DUMMY_TEST))
else
ifeq ($(DYN),)
$(eval $(call DUMMY_TEST))
else

EXTRA_FILES+=librelo.so libextern.so

THREAD_IMPL=native
LDFLAGS+=-athread=$(THREAD_IMPL)

$(PROG): main.o librelo.so libextern.so
# Not linked here, the function will be loaded at runtime
	$(call LOG_CMD,Link,$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS))

librelo.so: relo.o
	$(call LOG_CMD,Create Shared Object,$(CC) $(CFLAGS) -shared -o $@ $<)

relo.o: relo.c
	$(call LOG_CMD,Create Relocatable Object,$(CC) $(CFLAGS) -c -fPIC -o $@ $<)

libextern.so: extern.o
	$(call LOG_CMD,Create Shared Object,$(CC) $(CFLAGS) -shared -o $@ $<)

extern.o: extern.c
	$(call LOG_CMD,Create Relocatable Object,$(CC) $(CFLAGS) -c -fPIC -o $@ $<)

#@ Inside extern's someExternFn()
#@ Answer: 84
#@ Inside main's someExternFn()

endif
endif
