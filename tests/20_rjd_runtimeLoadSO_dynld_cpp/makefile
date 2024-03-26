include ../common.mak

# This test is just for clib4 dynamic
ifneq ($(C_LIB),clib4)
$(eval $(call DUMMY_TEST))
else
ifeq ($(DYN),)
$(eval $(call DUMMY_TEST))
else

EXTRA_FILES+=librelo.so

THREAD_IMPL=native
CFLAGS+=-athread=$(THREAD_IMPL)

$(PROG): main.cpp librelo.so
# Not linked here, the function will be loaded at runtime
	$(call LOG_CMD,Link,$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS))

librelo.so: relo.o
	$(call LOG_CMD,Create Shared Object,$(CXX) $(CXXFLAGS) -shared -o $@ $<)

relo.o: relo.cpp
	$(call LOG_CMD,Create Relocatable Object,$(CXX) $(CXXFLAGS) -c -fPIC -o $@ $<)

#@ Answer: 84

endif
endif
