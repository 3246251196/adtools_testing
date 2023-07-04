include ../common.mak

# This test is just for dynld, but a static version is also built anyway!

THREAD_IMPL?=native

CFLAGS+=-fPIC

$(PROG): main$(FILE_INFIX).o
	$(call LOG_CMD,Link,$(CXX) $(LDFLAGS) -athread=$(THREAD_IMPL) -o $@ $^ $(LIBS))
	$(call LOG_CMD,Readelf,$(READELF) -d $(PROG))

main$(FILE_INFIX).o: main.c
	$(call LOG_CMD,Compile,$(CC) $(CFLAGS) -c -o $@ $^)
