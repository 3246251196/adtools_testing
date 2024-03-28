include ../common.mak

# This test is just for clib4 dynamic
ifneq ($(C_LIB),clib4)
$(eval $(call DUMMY_TEST,CLIB4 DYNAMIC ONLY))
else
ifeq ($(DYN),)
$(eval $(call DUMMY_TEST,CLIB4 DYNAMIC ONLY))
else

EXTRA_FILES+=librelo.so

THREAD_IMPL=native
CFLAGS+=-athread=$(THREAD_IMPL)

$(PROG): main.c librelo.so
# Not linked here, the function will be loaded at runtime
#
# In this case, we do NOT want to use -use-dynld for the final
# executable linking phase
	$(call LOG_CMD,Link,$(CC) $(CFLAGS) -o $@ $< $(filter-out $(DYN),$(LDFLAGS)))

librelo.so: relo.o
	$(call LOG_CMD,Create Shared Object,$(CC) $(CFLAGS) -shared -o $@ $<)

relo.o: relo.c
	$(call LOG_CMD,Create Relocatable Object,$(CC) $(CFLAGS) -c -fPIC -o $@ $<)


#@ Answer: 84
endif
endif
