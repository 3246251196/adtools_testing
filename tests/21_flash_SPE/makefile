include ../common.mak

ifeq ($(shell $(CC) --version | grep -q '6.4.0' && echo $$?),0)

OBJECTS=A1222_SPE_floats.o
CFLAGS+=-mcpu=8540 -mtune=8540 -mspe -mabi=spe -mfloat-gprs=double

# As well as builing the original test, we also create a separate
# assembly file with nothing to do with the final main program so that
# we can look at the assembly. sum.S is pretty much the same as
# A1222_SPE_floats.c but it is just a standalone translation unit that
# does not pull in all the C library printf and start and stop code
ASM_FILES=sum.S
EXTRA_FILES=$(ASM_FILES)

$(OBJECTS): $(ASM_FILES)

$(PROG): $(OBJECTS)
	$(call LOG_CMD,Link,$(CC) $(LDFLAGS) -o $@ $(OBJECTS))

%.S: %.c
	$(call LOG_CMD,Assembly,$(CC) $(CFLAGS) -S -o $@ $<)

#@ should be 3: 3.000000

else
$(eval $(call DUMMY_TEST,GCC 6 ONLY))
endif

CLEAN_ME+=*.S $(PROG)
