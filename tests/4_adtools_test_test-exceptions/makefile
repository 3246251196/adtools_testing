include ../common.mak

LDFLAGS+=-athread=native

$(PROG): main$(FILE_INFIX).o
	$(call LOG_INF,Link,$@)
	$(call LOG_RUN,$(CXX) $(LDFLAGS) -o $@ $^)
	$(call LOG_INF,Readelf,$@)
	$(call LOG_RUN,ppc-amigaos-readelf -d $(PROG))

main$(FILE_INFIX).o: main.cpp
	$(call LOG_INF,Compile,$@)
	$(call LOG_RUN,$(CXX) $(CXXFLAGS) -c -o $@ $^)
