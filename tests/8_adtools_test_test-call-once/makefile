include ../common.mak

CXXFLAGS+=-std=c++11

THREAD_IMPL?=native
LIBS?=

$(PROG): main$(FILE_INFIX).o
	$(call LOG_CMD,Link,$(CXX) $(LDFLAGS) -o $@ $^ -athread=$(THREAD_IMPL) $(LIBS))
	$(call LOG_CMD,Readelf,$(READELF) -d $(PROG))

main$(FILE_INFIX).o: main.cpp
	$(call LOG_CMD,Compile,$(CXX) $(CXXFLAGS) -c -o $@ $^)


#@ Simple example: called once
#@ throw: call_once will retry
#@ throw: call_once will retry
#@ Didn't throw, call_once will not attempt again
