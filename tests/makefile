SHELL=/bin/bash
INSPECT_EXE=inspect.exe
LHA_ADD=lha u -q 1>/dev/null 2>&1
TMP_LOG_RESULTS_FILE=test_results.txt
export INSPECT_EXE
export LHA_ADD
# Nothing more than a long string of a bash export command that is used when
# invoking a specific test
# 
#######
# START EXPORT STRING
#######
ifeq ($(NO_VERBOSE),)
CFLAGS_VERBOSE=-v
LDFLAGS_VERBOSE=-Wl,--verbose
endif
EXPORT=INFIX="$${C_LIB}" ;                                                      \
	if [[ -z "$${DYN}" ]] ;                                                 \
	then                                                                    \
		INFIX="$${INFIX}_STATIC" ;                                      \
	else                                                                    \
		INFIX="$${INFIX}_DYNAMIC" ;                                     \
	fi ;                                                                    \
	CXX=ppc-amigaos-g++ ;                                                   \
	CC=ppc-amigaos-gcc ;                                                    \
	AR=ppc-amigaos-ar ;                                                     \
	RANLIB=ppc-amigaos-ranlib ;                                             \
	READELF=ppc-amigaos-readelf ;                                           \
	CFLAGS="${CLFLAGS} -gstabs -mcrt=$${C_LIB} $(CFLAGS_VERBOSE)" ;         \
	CXXFLAGS="${CXXFLAGS} -gstabs -mcrt=$${C_LIB} $(CFLAGS_VERBOSE)" ;      \
	LDFLAGS="${LDFLAGS} -mcrt=$${C_LIB} $${DYN} $(LDFLAGS_VERBOSE)" ;       \
	export C_LIB DYN INFIX CXX CC AR RANLIB READELF CFLAGS CXXFLAGS LDFLAGS
#######
# ENDER EXPORT STRING
#######

tests=$(shell ls -d */)
.PHONY: all $(FINAL_LHA) clean
all: $(FINAL_LHA)

$(FINAL_LHA): $(INSPECT_EXE) clean_stamp
ifeq ($(SCRIPT_INVOCATION),)
	$(error This makefile should only be invoked by the "adt" script)
endif
	for C_LIB in "newlib" "clib2" ;                                                     \
	do                                                                                  \
		for DYN in "-use-dynld" "" ;                                                \
		do                                                                          \
			$(EXPORT) ;                                                         \
			for TEST in $(tests) ;                                              \
			do                                                                  \
				$(MAKE) -C "$${TEST}" all 1>>$(TMP_LOG_RESULTS_FILE) 2>&1 & \
				pids+=( $$! ) ;                                             \
			done ;                                                              \
		done ;                                                                      \
	done ;                                                                              \
	for p in $${pids[@]} ; do wait $$p ; done
	sort -o $(TMP_LOG_RESULTS_FILE) $(TMP_LOG_RESULTS_FILE)
	cat $(TMP_LOG_RESULTS_FILE)
	cd .. && $(LHA_ADD)                                   \
		$@                                            \
		tests/*/*.lha                                 \
		tests/$(EXECUTE_SCRIPT)                       \
		tests/$(TMP_LOG_RESULTS_FILE)                 \
			&& cd - 1>/dev/null 2>&1              \
			&& $(LHA_ADD) ../$@ $(RUN_ALL_SCRIPT)
	rm $(TMP_LOG_RESULTS_FILE)
	CLIB2_LIBRARY_LOC=$$(find $(BASE_DIR)/$(ADTOOLS_DIR)/native-build/downloads/clib2 \
				-name "clib2.library") ;                                  \
	if [[ -n $${CLIB2_LIBRARY_LOC} ]] ;                                               \
	then                                                                              \
		cp $${CLIB2_LIBRARY_LOC} . ;                                              \
		cd .. ;                                                                   \
		$(LHA_ADD) $@ tests/clib2.library ;                                       \
		cd - 1>/dev/null 2>&1 ;                                                   \
		rm clib2.library ;                                                        \
	fi

clean_stamp: $(BASE_DIR)
	$(do_clean)
	touch $@

clean:
	$(do_clean)

$(INSPECT_EXE): inspect.c
	ppc-amigaos-gcc -mcrt=newlib -o $@ $< -Wall -Werror -pedantic -std=c11

do_clean=                                                                  \
	for TEST in $(tests) ;                                             \
	do                                                                 \
		$(MAKE) -C "$${TEST}" clean ;                              \
	done
