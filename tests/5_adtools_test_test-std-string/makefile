include ../common.mak

CXXFLAGS+=-ffunction-sections -fdata-sections -std=c++11
LDFLAGS+=-std=c++11 -athread=native -Wl,-Map=$@.map,--cref -Wl,--gc-sections -Wl,--verbose

$(PROG): main$(FILE_INFIX).o
	$(call LOG_INF,Link,$@)
	$(call LOG_RUN,$(CXX) $(LDFLAGS) -o $@ $^)
	$(call LOG_INF,Readelf,$@)
	$(call LOG_RUN,ppc-amigaos-readelf -d $(PROG))

main$(FILE_INFIX).o: main.cpp
	$(call LOG_INF,Compile,$@)
	$(call LOG_RUN,$(CXX) $(CXXFLAGS) -c -o $@ $^)
