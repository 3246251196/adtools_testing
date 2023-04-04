include ../common.mak

LDFLAGS+=-use-dynld -athread=native

CFLAGS+=-fPIC

$(PROG): main$(FILE_INFIX).o
	$(call LOG_INF,Link,$@)
	$(call LOG_RUN,$(CXX) $(LDFLAGS) -o $@ $^)
	$(call LOG_INF,Readelf,$@)
	$(call LOG_RUN,ppc-amigaos-readelf -d $(PROG))

main$(FILE_INFIX).o: main.c
	$(call LOG_INF,Compile,$@)
	$(call LOG_RUN,$(CC) $(CFLAGS) -c -o $@ $^)
