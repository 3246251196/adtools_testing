# The common makefile framework must always be included
include ../common.mak

# Further overriding flags. The default already contains the necessary C LIBRARY
# and any other flags passed by the user via the adt script
CXXFLAGS+=-Wall -Werror -pedantic -std=c++11
LDFLAGS+=-athread=native

# $(PROG) is the only necessary rule.
# Note the use of $(call) to write to the log file
$(PROG): main_$(FILE_INFIX).o
	$(call LOG_RUN,Link,$(CXX) $(LDFLAGS) -o $@ $^)
	$(call LOG_RUN,Readelf,$(READELF) -d $(PROG))

main_$(FILE_INFIX).o: main.cpp
	$(call LOG_RUN,Compile,$(CXX) $(CXXFLAGS) -c -o $@ $^)

# In this case, as well as the executable returning status 0, we want to check
# that its output is as we expected. Any line that begins with '#@' is assumed
# to be an expected output. The inspection test will strip away '#@ '. These
# lines can occur anywhere in the script and can be staggered but generally it
# makes senses to just put them at the end of the makefile.

#@ 2
#@ 3
#@ 5
#@ 7
