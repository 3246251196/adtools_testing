include ../common.mak

LDFLAGS+=-athread=native

$(PROG): main$(FILE_INFIX).o
	$(call LOG_RUN,Link,$(CXX) $(LDFLAGS) -o $@ $^)
	$(call LOG_RUN,Readelf,$(READELF) -d $(PROG))

main$(FILE_INFIX).o: main.cpp
	$(call LOG_RUN,Compile,$(CXX) $(CXXFLAGS) -c -o $@ $^)
