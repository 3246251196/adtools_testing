include ../common.mak

RELO:=lib.o
ifeq ($(NO_DYN),)
LIB:=libf.so
else
LIB:=libf.a
endif

LDFLAGS+=-L. -lf 

$(PROG): main.c $(LIB)
	$(call LOG_INF,Link,$@)
	$(call LOG_RUN,$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS))
	$(call LOG_INF,Readelf,$@)
	$(call LOG_RUN,ppc-amigaos-readelf -d $(PROG))
	$(call LOG_EXT,"####################")
	$(call LOG_EXT,"####################")
	$(call LOG_EXT,"####################")
	$(call LOG_EXT,"Expected output when invoking: $(PROG)")
	$(call LOG_EXT,"--------------------")
	$(call LOG_EXT,"ctor")
	$(call LOG_EXT,"ctor2")
	$(call LOG_EXT,"function 123")
	$(call LOG_EXT,"main result 123")
	$(call LOG_EXT,"dtor2")
	$(call LOG_EXT,"dtor")
	$(call LOG_EXT,"--------------------")
	$(call LOG_EXT,"####################")
	$(call LOG_EXT,"####################")
	$(call LOG_EXT,"####################")

$(LIB): $(RELO)
ifeq ($(NO_DYN),)
	$(call LOG_INF,Creating Shared Object,$@)
	$(call LOG_RUN,$(CC) $(CFLAGS) -o libf.so lib.o -shared)
else
	$(call LOG_INF,Creating Static Library,$@)
	$(call LOG_RUN,$(AR) cruv  libf.a lib.o)
	$(call LOG_RUN,$(RANLIB) libf.a)
endif

$(RELO): lib.c
	$(call LOG_INF,Compile,$@)
	$(call LOG_RUN,$(CC) $(CFLAGS) -o lib.o -c lib.c -fPIC)
