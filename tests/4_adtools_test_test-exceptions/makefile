include ../common.mak

THREAD_IMPL?=native

$(PROG): main$(FILE_INFIX).o
	$(call LOG_CMD,Link,$(CXX) $(LDFLAGS) -athread=$(THREAD_IMPL) -o $@ $^ $(LIBS))
	$(call LOG_CMD,Readelf,$(READELF) -d $(PROG))

main$(FILE_INFIX).o: main.cpp
	$(call LOG_CMD,Compile,$(CXX) $(CXXFLAGS) -c -o $@ $^)
