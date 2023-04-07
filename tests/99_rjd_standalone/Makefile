# Do not have to use all the test framework. These test case will still get built. The only requirement is an all and a clean target.
#
# But, you probably want to use override to forcefully define your own variables
override CXX = ppc-amigaos-g++
override CXXFLAGS = 
override LDFLAGS = -athread=native
all: main.exe
main.exe: main.cpp
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) 1>/dev/null 2>&1
clean:
	-@rm -f main.exe
