include ../common.mak

# We are only interested in GCC version 6
ifeq ($(shell $(CC) --version | grep -q '6.4.0' && echo $$?),0)

ifneq ($(DYN),)
THREAD_IMPL?=native
LDFLAGS+=-athread=$(THREAD_IMPL)
endif

CFLAGS+=-mspe -mcpu=8540 -mfloat-gprs=double -mabi=spe

$(PROG): main.c
	$(call LOG_CMD,Link,$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<)

else
$(eval $(call DUMMY_TEST,GCC 6 ONLY))
endif

#@ 1/0: inf
