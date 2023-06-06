include ../common.mak

# TODO: Investigate why this is needed when essentially using libstdc++.so.
#       For the investigator: Remove this option, and read the log*DYNAMIC files
#
#       Maybe this is fine. I have not looked into it in great detail!
ifneq ($(DYN),)
LDFLAGS+=-athread=native
endif

CFLAGS+=-Wall -Wextra -Werror -pendantic -std=c++11

# During the development of Webkit we were having an issue with multiple
# definitions for some math functions. During ADTOOLS the library libstdc++ is
# built. It includes - for example - floorl. But, so does the clib2 library. For
# whatever reason during linking of something in Webkit, it brings in the object
# file `math_stubs_long_double.o' and `stubs.o' from the CLIB2 library
# libc. This test was an attempt to reproduce the issue, but I cannot unless I
# explicitly add:
#
# Regardless, we should probably be telling libstdc++ that WE already have that
# file defined!
#
# This object file will not exist unless you still have your ADTOOLS build
# non-cleaned
#
###
# UNCOMMENT THIS LINE TO FORCE THE ERROR:
#LDFLAGS+=/path/to/your/math_stubs_long_double.o
###

$(PROG): main_$(FILE_INFIX).o
	$(call LOG_CMD,Link,$(CXX) $(LDFLAGS) -o $@ $^)
	$(call LOG_CMD,Readelf,$(READELF) -d $(PROG))

main_$(FILE_INFIX).o: main.cpp
	$(call LOG_CMD,Compile,$(CXX) $(CXXFLAGS) -c -o $@ $^)

#@ 1.000
#@ 42.000
#@ 43.000
