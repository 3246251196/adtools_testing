# The common makefile framework must always be included
include ../common.mak

# A variable that can be used to archive additional files specific to the test
#
# It is suggested to put extra files in a directory since the Makefile clean rules
# often remove things like *.txt etc
EXTRA_FILES+=EXTRAS/readme.txt

# Further overriding flags. The default already contains the necessary C LIBRARY
# and any other flags passed by the user via the adt script
CXXFLAGS+=-Wall -Werror -pedantic -std=c++11

# We need to also apply the -athread option since when doing a dynamic
# build, libgcc.so relies on some threading functions that are only
# brought in with gthr-amigaos-$(THREAD_IMPL).o
#
# We ALSO need it for static since
# IOSTREAM ends up needing routines in gthr-amigaos-$(THREAD_IMPL).o
# also
THREAD_IMPL?=native
LDFLAGS+=-athread=$(THREAD_IMPL)

# $(PROG) is the only necessary rule.
# Note the use of $(call) to write to the log file
$(PROG): main_$(FILE_INFIX).o
	$(call LOG_CMD,Link,$(CXX) $(LDFLAGS) -o $@ $^)
	$(call LOG_CMD,Readelf,$(READELF) -d $(PROG))

main_$(FILE_INFIX).o: main.cpp
	$(call LOG_CMD,Compile,$(CXX) $(CXXFLAGS) -c -o $@ $^)

# In this case, as well as the executable returning status 0, we want to check
# that its output is as we expected. Any line that begins with '#@ ' is assumed
# to be an expected output. The inspection test will strip away '#@ '. These
# lines can occur anywhere in the script and can be staggered but generally it
# makes senses to just put them at the end of the makefile.

#@ 2
#@ 3
#@ 5
#@ 7
