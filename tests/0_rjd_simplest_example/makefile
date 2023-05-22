include ../common.mak

LDFLAGS+=-athread=native

$(PROG): main.c
	$(call LOG_CMD,Link,$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<)
