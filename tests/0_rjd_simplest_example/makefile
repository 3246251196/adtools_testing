include ../common.mak

# TODO, figure out why we need to even use -athread for this test!
THREAD_IMPL?=native

$(PROG): main.c
	$(call LOG_CMD,Link,$(CC) $(CFLAGS) $(LDFLAGS) -athread=$(THREAD_IMPL) -o $@ $< $(LIBS))
