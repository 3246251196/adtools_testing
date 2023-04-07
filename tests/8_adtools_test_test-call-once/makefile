include ../common.mak

CXXFLAGS+=-std=c++11
LDFLAGS+=-athread=native

$(PROG): main$(FILE_INFIX).o
	$(call LOG_RUN,Link,$(CXX) $(LDFLAGS) -o $@ $^)
	$(call LOG_RUN,Readelf,$(READELF) -d $(PROG))

main$(FILE_INFIX).o: main.cpp
	$(call LOG_RUN,Compile,$(CXX) $(CXXFLAGS) -c -o $@ $^)

#@ Simple example: called once
#@ throw: call_once will retry
#@ throw: call_once will retry
#@ Didn't throw, call_once will not attempt again
