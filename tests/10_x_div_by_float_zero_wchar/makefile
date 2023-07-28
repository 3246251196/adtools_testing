include ../common.mak

ifneq ($(DYN),)
THREAD_IMPL?=native
LDFLAGS+=-athread=$(THREAD_IMPL)
endif

ifneq ($(SPE),)
CFLAGS+=-mspe -mcpu=8540 -mfloat-gprs=double -mabi=spe
endif

$(PROG): main.c
	$(call LOG_CMD,Link,$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<)

#@ 1/0: inf
