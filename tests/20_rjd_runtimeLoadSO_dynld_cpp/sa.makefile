CXX=ppc-amigaos-g++
CXXFLAGS=-mcrt=clib4 -Wall -Wextra

V?=0
ifeq ($(V),1)
CXXFLAGS+=-v -Wl,--verbose
endif

.PHONY: all
all: main

main: main.o librelo.so
	$(CXX) $(CXXFLAGS) -use-dynld -athread=native -o $@ $<

main.o: main.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

relo.o: relo.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $< -fPIC

librelo.so: relo.o
	$(CXX) $(CXXFLAGS) -shared -o $@ $<

clean:
	-rm *.o *.so main
