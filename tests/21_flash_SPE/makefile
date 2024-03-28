include ../common.mak

ifeq ($(shell $(CC) --version | grep -q '6.4.0' && echo $$?),0)

OBJECTS=A1222_SPE_floats.o
CFLAGS+=-mcpu=8540 -mtune=8540 -mspe -mabi=spe -mfloat-gprs=double

ASM_FILES=$(foreach OBJ,$(OBJECTS),$(patsubst %.o,%.S,$(OBJ)))
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
