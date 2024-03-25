PROG=main
SO=libsharedObj.so

C_LIB?=clib4
CXX=ppc-amigaos-g++
CXXFLAGS=-Wall -Wextra -pedantic -v -Wl,--verbose -mcrt=$(C_LIB)
LDFLAGS=-use-dynld  -L. -athread=native
LDLIBS=-l$(patsubst lib%.so,%,$(SO)) -lpthread

all: $(PROG)

$(PROG): $(PROG).o $(SO)
	$(CXX) -o $(PROG) $< $(LDFLAGS) $(LDLIBS) $(CXXFLAGS)

$(PROG).o: main.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS)

$(SO): $(patsubst lib%.so,%.o,$(SO))
	$(CXX) -shared -o $@ $< $(CXXFLAGS)

$(patsubst lib%.so,%.o,$(SO)): $(patsubst lib%.so,%.c,$(SO))
	$(CXX) -c -o $@ $< -fPIC $(CXXFLAGS)

.PHONY: clean
clean:
	-rm -f main main.o sharedObj.o libsharedObj.so
