include ../common.mak

THREAD_IMPL=native
LIBS+=-lpthread
LDFLAGS+=-athread=native

$(PROG): tls.c
	$(call LOG_CMD,Link,$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $< $(LIBS))
