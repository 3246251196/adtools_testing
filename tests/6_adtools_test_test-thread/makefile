include ../common.mak

CXXFLAGS+=-ffunction-sections -fdata-sections -std=c++11
LDFLAGS+=-std=c++11 -athread=native -Wl,-Map=$@.map,--cref -Wl,--gc-sections -Wl,--verbose

$(PROG): main$(FILE_INFIX).o
	$(call LOG_RUN,Link,$(CXX) $(LDFLAGS) -o $@ $^)
	$(call LOG_RUN,Readelf,$(READELF) -d $(PROG))

main$(FILE_INFIX).o: main.cpp
	$(call LOG_RUN,Compile,$(CXX) $(CXXFLAGS) -c -o $@ $^)
