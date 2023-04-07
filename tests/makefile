SHELL=/bin/bash
INSPECT_EXE=inspect.exe
export INSPECT_EXE
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
	READELF=ppc-amigaos-readelf ;                  \
	CFLAGS="${CLFLAGS} -mcrt=$${C_LIB}" ;          \
	CXXFLAGS="${CXXFLAGS} -mcrt=$${C_LIB}" ;       \
	LDFLAGS="${LDFLAGS} -mcrt=$${C_LIB} $${DYN}" ;
ifeq ($(NO_VERBOSE),)
	EXPORT+=                                       \
		CXXFLAGS="${CXXFLAGS} -v" ;            \
		CFLAGS="${CFLAGS} -v" ;                \
		LDFLAGS="${LDFLAGS} -Wl,--verbose";
endif
	EXPORT+=export \
		C_LIB DYN INFIX CXX CC AR RANLIB READELF CFLAGS CXXFLAGS LDFLAGS
#######
# ENDER EXPORT STRING
#######

do_clean=                                     \
	for TEST in $(tests) ;                \
	do                                    \
		$(MAKE) -C "$${TEST}" clean ; \
	done ;                                \

tests=$(shell ls -d */)
.PHONY: all clean
all: $(INSPECT_EXE) clean_stamp
ifeq ($(SCRIPT_INVOCATION),)
	$(error This makefile should only be invoked by the "4afx" script)
endif
	for C_LIB in "newlib" "clib2" ;                     \
	do                                                  \
		for DYN in "-use-dynld" "" ;                \
		do                                          \
			$(EXPORT) ;                         \
			for TEST in $(tests) ;              \
			do                                  \
				$(MAKE) -C "$${TEST}" all & \
				pids+=( $$! ) ;             \
			done ;                              \
		done ;                                      \
	done ;                                              \
	for p in $${pids[@]} ; do wait $$p ; done

clean_stamp: $(BASE_DIR)
	$(do_clean)
	touch $@

clean:
	$(do_clean)

# TODO: Use a tool that is available to AmigaOS4 base package to compare lines. ARREX?
#       Not everyone has the SDK installed, so DIFF is not always available!
$(INSPECT_EXE): inspect.c
	ppc-amigaos-gcc -mcrt=newlib -o $@ $< -Wall -Werror -pedantic -std=c11
