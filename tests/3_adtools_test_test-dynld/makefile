include ../common.mak

LDFLAGS+=-use-dynld -athread=native

CFLAGS+=-fPIC

$(PROG): main$(FILE_INFIX).o
	$(call LOG_RUN,Link,$(CXX) $(LDFLAGS) -o $@ $^)
	$(call LOG_RUN,Readelf,$(READELF) -d $(PROG))

main$(FILE_INFIX).o: main.c
	$(call LOG_RUN,Compile,$(CC) $(CFLAGS) -c -o $@ $^)
