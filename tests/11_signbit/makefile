include ../common.mak

ifneq ($(DYN),)
THREAD_IMPL?=native
LDFLAGS+=-athread=$(THREAD_IMPL)
endif

ifneq ($(SPE),)
CFLAGS+=-mspe -mcpu=8540 -mfloat-gprs=double -mabi=spe
endif

LIBS=-lm

$(PROG): main.c
	$(call LOG_CMD,Link,$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(LIBS) $<)

#@ signbit(0.0)       : 0
#@ signbit(1.0/0.0)   : 0
#@ signbit(-1.0/0.0)  : 1
#@ signbit(sqrt(-1.0)): 1
