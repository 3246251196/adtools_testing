include ../common.mak

# We are only interested in GCC version 6
ifeq ($(shell $(CC) --version | grep '6.4.0' && echo $$?),0)

ifneq ($(DYN),)
THREAD_IMPL?=native
LDFLAGS+=-athread=$(THREAD_IMPL)
endif

CFLAGS+=-mspe -mcpu=8540 -mfloat-gprs=double -mabi=spe

LIBS=-lm

$(PROG): main.c
	$(call LOG_CMD,Link,$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(LIBS) $<)

else
$(eval $(call DUMMY_TEST))
endif

#@ signbit(0.0)       : 0
#@ signbit(1.0/0.0)   : 0
#@ signbit(-1.0/0.0)  : 1
#@ signbit(sqrt(-1.0)): 1
