SHELL=/bin/bash

# Nothing more than a long string of a bash export command that is used when
# invoking a specific test
# 
#######
# START EXPORT STRING
#######
EXPORT=INFIX="$${C_LIB}" ;                             \
	if [[ -z "$${DYN}" ]] ;                        \
	then                                           \
		INFIX="$${INFIX}_STATIC" ;             \
	else                                           \
		INFIX="$${INFIX}_DYNAMIC" ;            \
	fi ;                                           \
	CXX=ppc-amigaos-g++ ;                          \
	CC=ppc-amigaos-gcc ;                           \
	AR=ppc-amigaos-ar ;                            \
	RANLIB=ppc-amigaos-ranlib ;                    \
	CFLAGS="${CLFLAGS} -mcrt=$${C_LIB}" ;          \
	CXXFLAGS="${CXXFLAGS} -mcrt=$${C_LIB}" ;       \
	LDFLAGS="${LDFLAGS} -mcrt=$${C_LIB} $${DYN}" ;
ifeq ($(NO_VERBOSE),)
	EXPORT+=                                       \
		CXXFLAGS="${CXXFLAGS} -v" ;            \
		CFLAGS="${CFLAGS} -v" ;                \
		LDFLAGS+="${LDFLAGS} -Wl,--verbose";
endif
	EXPORT+=export \
		C_LIB DYN INFIX CXX CC AR RANLIB CFLAGS CXXFLAGS LDFLAGS
#######
# ENDER EXPORT STRING
#######

tests=$(shell ls -d */)
.PHONY: all
all: clean_stamp
ifeq ($(SCRIPT_INVOCATION),)
	$(error This makefile should only be invoked by the "4afx" script)
endif
	for C_LIB in "newlib" "clib" ;                                   \
	do                                                               \
		for DYN in "-use-dynld" "" ;                             \
		do                                                       \
			$(EXPORT) ;                                      \
			for TEST in $(tests) ;                           \
			do                                               \
				$(MAKE) -C "$${TEST}" all ;              \
			done ;                                           \
		done ;                                                   \
	done

clean_stamp: $(BASE_DIR)
	for TEST in $(tests) ;                \
	do                                    \
		$(MAKE) -C "$${TEST}" clean ; \
	done                                  \
	&& touch clean_stamp
