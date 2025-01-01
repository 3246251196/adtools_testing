include ../common.mak

THREAD_IMPL=native
LIBS+=-lpthread
LDFLAGS+=-athread=native
CPPFLAGS+=-DLARGE -DTHREAD

$(PROG): tls.c
	$(call LOG_CMD,Link,$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $< $(LIBS))

#@ Created thread val of i : 1000000001
#@ Parent thread val of i  : 0
