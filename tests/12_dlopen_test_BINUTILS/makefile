include ../common.mak

# We do not care about static variants. Just create a dummy passing test:
ifeq ($(DYN),)
$(eval $(call DUMMY_TEST,DYNAMIC VARIANTS ONLY))
else
CFLAGS+=-Wall -Wpedantic
THREAD_IMPL?=native
LDFLAGS+=-athread=$(THREAD_IMPL)

# Remember that the framework builds 4 variants, so we want uniqueness
# here. For that, use $(FILE_INFIX):
LIBCAT=lib$(FILE_INFIX)cat.so
LIBDOG=lib$(FILE_INFIX)dog.so
SOs=$(LIBCAT) $(LIBDOG)

ifeq ($(C_LIB),newlib)
LIBS=-ldl
endif

$(PROG): $(SOs) dlopen_sample.c
	$(call LOG_CMD,Link,$(CC) dlopen_sample.c $(CFLAGS) -o $@ $(LDFLAGS) $(LIBS))

$(LIBCAT): cat.c
	$(call LOG_CMD,Creating Shared Object,$(CC) -shared -fPIC $< $(CFLAGS) -o $@)

$(LIBDOG): dog.c
	$(call LOG_CMD,Creating Shared Object,$(CC) -shared -fPIC $< $(CFLAGS) -o $@)

# Expected output:

#@ argv1 = dog
#@ Pochi is a dog.
#@ Closing handle
#@ argv1 = cat
#@ Called
#@ Tama is a cat.
#@ Pochi is a print_name
#@ .
#@ Closing handle

endif

