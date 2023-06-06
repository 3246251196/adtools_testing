include ../common.mak

# TODO: Investigate why this is needed when essentially using libstdc++.so.
#       For the investigator: Remove this option, and read the log*DYNAMIC files
#
#       Maybe this is fine. I have not looked into it in great detail!
ifneq ($(DYN),)
LDFLAGS+=-athread=native
endif

CFLAGS+=-Wall -Wextra -Werror -pendantic -std=c++11

$(PROG): main_$(FILE_INFIX).o
	$(call LOG_CMD,Link,$(CXX) $(LDFLAGS) -o $@ $^)
	$(call LOG_CMD,Readelf,$(READELF) -d $(PROG))

main_$(FILE_INFIX).o: main.cpp
	$(call LOG_CMD,Compile,$(CXX) $(CXXFLAGS) -c -o $@ $^)

#@ 1.000
#@ 42.000
#@ 43.000
