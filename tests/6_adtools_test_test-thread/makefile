include ../common.mak

CXXFLAGS+=-ffunction-sections -fdata-sections -std=c++11
LDFLAGS+=-std=c++11 -Wl,-Map=$@.map,--cref -Wl,--gc-sections -Wl,--verbose

THREAD_IMPL?=native
LIBS?=

$(PROG): main$(FILE_INFIX).o
	$(call LOG_CMD,Link,$(CXX) $(LDFLAGS) -o $@ $^ -athread=$(THREAD_IMPL) $(LIBS))
	$(call LOG_CMD,Readelf,$(READELF) -d $(PROG))

main$(FILE_INFIX).o: main.cpp
	$(call LOG_CMD,Compile,$(CXX) $(CXXFLAGS) -c -o $@ $^)
