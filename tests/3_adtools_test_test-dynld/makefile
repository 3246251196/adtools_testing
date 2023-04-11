include ../common.mak

LDFLAGS+=-use-dynld -athread=native

CFLAGS+=-fPIC

$(PROG): main$(FILE_INFIX).o
	$(call LOG_CMD,Link,$(CXX) $(LDFLAGS) -o $@ $^)
	$(call LOG_CMD,Readelf,$(READELF) -d $(PROG))

main$(FILE_INFIX).o: main.c
	$(call LOG_CMD,Compile,$(CC) $(CFLAGS) -c -o $@ $^)
