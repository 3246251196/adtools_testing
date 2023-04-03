SHELL:=/bin/bash
C_LIB?=clib2
ifeq ($(NO_DYN),)
DYN:=-use-dynld
INFIX:=DYNAMIC_$(C_LIB)
# LDFLAGS=-shared # Testing out adding -shared to creating an exe
else
INFIX:=STATIC_$(C_LIB)
LDFLAGS:=
endif

CXX:=ppc-amigaos-g++
CXXFLAGS:=-mcrt=$(C_LIB)

CC:=ppc-amigaos-gcc
CFLAGS:=-mcrt=$(C_LIB)

LDFLAGS:=-mcrt=$(C_LIB) $(DYN)

AR:=ppc-amigaos-ar
RANLIB:=ppc-amigaos-ranlib

ifeq ($(NO_VERBOSE),)
CXXFLAGS+=-v
CFLAGS+=-v
LDFLAGS+=-Wl,--verbose
endif

export

tests:=$(shell ls -d */)

.PHONY: all clean
all:
ifneq (0,$(shell which ppc-amigaos-gcc 1>/dev/null 2>&1 ; echo $$?))
	$(error Could not find "ppc-amigaos-gcc" on the path)
endif
	for t in $(tests) ; do $(MAKE) -C $$t all ; done

clean:
	for t in $(tests) ; do $(MAKE) -C $$t clean ; done
