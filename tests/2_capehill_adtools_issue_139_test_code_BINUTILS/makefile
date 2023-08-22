include ../common.mak

# Notice that FILE_INFIX is used to create separate files depending on the c
# library / link type contexts. This is important because to get quick build
# times all the tests are build in parallel. Since each test has 4 dimenions
# (2*c library * 2*link type) then the same build could be using changing files
#
# This is only an issue for any files that the specific test produces everything
# else is handled by the test framework.
#
# In summary, any relocatables or libraries (.o, .so, .a) should use the
# FILE_INFIX variable in their names
LIB_NAME=f_$(FILE_INFIX)
RELO=$(LIB_NAME).o
ifneq ($(DYN),)
LIB=lib$(LIB_NAME).so
else
LIB=lib$(LIB_NAME).a
endif

CFLAGS+=-Wall -Werror -pedantic -std=c11 -fPIC
LDFLAGS+=-L. -l$(LIB_NAME)
THREAD_IMPL?=native

$(PROG): main.c $(LIB)
	$(call LOG_CMD,Link,$(CC) -o $@ $< $(LDFLAGS) -athread=$(THREAD_IMPL) $(LIBS))
	$(call LOG_CMD,Readelf,$(READELF) -d $(PROG))

$(LIB): $(RELO)
ifneq ($(DYN),)
	$(call LOG_CMD,Creating Shared Object,$(CC) $(CFLAGS) -o $(LIB) $(RELO) -shared)
else
	$(call LOG_CMD,Creating Static Library,$(AR) cruv $(LIB) $(RELO))
	$(call LOG_CMD,ranlib,$(RANLIB) $(LIB))
endif

$(RELO): lib.c
	$(call LOG_CMD,Compile Library Relocatable -fPIC,$(CC) $(CFLAGS) -o $(RELO) -c $<)

#@ ctor
#@ ctor2
#@ function 123
#@ main result 123
#@ dtor2
#@ dtor
