include ../common.mak

# We need to also apply the -athread option since when doing a dynamic
# build, libgcc.so relies on some threading functions that are only
# brought in with gthr-amigaos-$(THREAD_IMPL).o
ifneq ($(DYN),)
THREAD_IMPL?=native
LDFLAGS+=-athread=$(THREAD_IMPL)
endif

$(PROG): main.c
	$(call LOG_CMD,Link,$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $< $(LIBS))
