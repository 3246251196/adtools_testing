include ../common.mak

# This is a clib4 test
ifeq ($(C_LIB),clib4)
SO=libsharedObj.so

CXXFLAGS+=-Wall -Wextra -pedantic
THREAD_IMPL?=native
LDFLAGS+=-L. -athread=$(THREAD_IMPL)
LDLIBS=-l$(patsubst lib%.so,%,$(SO)) -lpthread

$(PROG): $(PROG).o $(SO)
	$(call LOG_CMD,Link,$(CXX) -o $(PROG) $< $(LDFLAGS) $(LDLIBS))

$(PROG).o: main.cpp
	$(call LOG_CMD,Compile Relocatable Object,$(CXX) -c -o $@ $< $(CXXFLAGS))

$(SO): $(patsubst lib%.so,%.o,$(SO))
	$(call LOG_CMD,Creating Shared Object,$(CXX) $(CXXFLAGS) -shared -o $@ $<)

$(patsubst lib%.so,%.o,$(SO)): $(patsubst lib%.so,%.cpp,$(SO))
	$(call LOG_CMD,Creating FPIC object,$(CXX) -c -o $@ $< -fPIC $(CXXFLAGS))
else
$(eval $(call DUMMY_TEST))
endif

#@ Count: 100000000
