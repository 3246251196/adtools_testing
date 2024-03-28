SHELL=/bin/bash
INSPECT_EXE=inspect.exe
DUMMY_EXE=dummy.exe
LHA_ADD=lha u -q 1>/dev/null 2>&1
TMP_LOG_RESULTS_FILE=test_build_results.txt
PREFIX=$(subst /,_,$(subst .,_,$(CROSS_PREFIX)))

# Ensure the created link does not contain the word 'clib4' or 'clib2' It does
# not matter what we call our link since we use it internally:
#
# This is a workaround in the case that the prefix contains the string 'clib4'
# or 'clib2' otherwise the variable $(LOC) in the common.mak will not work as
# expected during the invocation of `find' for which we seek the SO files in the
# prefix.
CP_ROOT=$(subst clib2,CLIB2,$(subst clib4,CLIB4,$(PREFIX)_cp_root))

CLEAN_STAMP=$(PREFIX)_clean_stamp
export INSPECT_EXE
export DUMMY_EXE
export LHA_ADD
export CP_ROOT

# Prepare the dimensionality of the testing which defaults to the cross product
# of C_LIB_LIST and LINKER_TYPE_LIST.
C_LIB_LIST?="newlib" "clib2" "clib4"
LINKER_TYPE_LIST?="-use-dynld" ""

# Nothing more than a long string of a bash export command that is used when
# invoking a specific test
#
#######
# START EXPORT STRING
#######
ifeq ($(NO_VERBOSE),)
# We add the linker verbosity in the case of creating a shared object. $(CC) is
# called without $(LDFLAGS) there, so just add verbsoity options to everything
# since there is no harm
CFLAGS_VERBOSE=-v -Wl,--verbose
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

# Handle the case that a specific test pattern has been provided
ifneq ($(TEST_PATTERN),)
PATTERN1=$(TEST_PATTERN)*
PATTERN2=-name "*$(PATTERN1)"
endif
# We do not want to include standalone tests. Those are tests that have a file
# named makefile/Makefile that doesn't contain: "include ../common.mak"
# somewhere in them.
#
# Note that a test may contain a file named sa.makefile as well as a
# makeile. This is so that the test can be build in standalone mode if desired
# but it is not considered a standalone test because it includes a [Mm]akefile
# with the inclusion of common.mak!
tests=$(shell grep -l 'include ../common.mak' *$(PATTERN1)/[Mm]akefile | cut -f1 -d'/')
# All Standlone tests:
sa_tests=$(filter-out $(tests),$(shell find -maxdepth 1 -mindepth 1 -type d $(PATTERN2) -exec basename {} \;))

# Handle debugging
ifeq ($(DEBUG_MAKE),1)
OUTPUT_STYLE=2>&1 | tee -a $(TMP_LOG_RESULTS_FILE) ;
else
OUTPUT_STYLE=1>>$(TMP_LOG_RESULTS_FILE) 2>&1 &
endif

.PHONY: all $(FINAL_LHA) clean
all: $(FINAL_LHA)

$(FINAL_LHA): $(INSPECT_EXE) $(DUMMY_EXE) $(CLEAN_STAMP)
ifeq ($(SCRIPT_INVOCATION),)
	$(error This makefile should only be invoked by the "adt" script)
endif
	ln -s -f "$(CROSS_PREFIX)" $(CP_ROOT) 1>/dev/null 2>&1
	for C_LIB in $(C_LIB_LIST) ;                                      \
	do                                                                \
		for DYN in $(LINKER_TYPE_LIST) ;                          \
		do                                                        \
			$(EXPORT) ;                                       \
			for TEST in $(tests) ;                            \
			do                                                \
				$(MAKE) -C "$${TEST}" all $(OUTPUT_STYLE) \
				pids+=( $$! ) ;                           \
			done ;                                            \
		done ;                                                    \
	done ;                                                            \
	for p in $${pids[@]} ; do wait $$p ; done
	sort -o $(TMP_LOG_RESULTS_FILE) $(TMP_LOG_RESULTS_FILE)
	cat $(TMP_LOG_RESULTS_FILE)
ifneq ($(TEST_PATTERN),)
	echo "!!! NOTE !!! This file only contains the build results for test(s): \"$(tests) $(sa_tests)\"" \
	" due to the use of the -S (test pattern subset option)" >> $(TMP_LOG_RESULTS_FILE)
endif
	cd .. && $(LHA_ADD)                                         \
		$@                                                  \
		tests/*/*.lha                                       \
		tests/$(EXECUTE_SCRIPT)                             \
		tests/$(TMP_LOG_RESULTS_FILE)                       \
			&& cd - 1>/dev/null 2>&1                    \
			&& $(LHA_ADD) ../$@ $(RUN_ALL_SCRIPT)       \
			&& $(LHA_ADD) ../$@ $(RUN_ALL_LINUX_SCRIPT)
	rm $(TMP_LOG_RESULTS_FILE)
# Now, attempt any standalone tests. Do not fail on error, and add them to the archive
	echo "    Building Standalone tests. No logging is performed for Standalone tests; see their log.txt"
	mkdir Standalone_Tests
	-for TEST in $(sa_tests) ;                              \
	do                                                      \
		$(MAKE) -C "$${TEST}" 1>$${TEST}/log.txt 2>&1 & \
		pids+=( $$! ) ;                                 \
	done ;                                                  \
	for p in $${pids[@]} ; do wait $$p ; done
	-for TEST in $(sa_tests) ;                \
	do                                        \
		cp -r $${TEST} Standalone_Tests ; \
	done ;                                    \
	$(LHA_ADD) ../$@ Standalone_Tests/
	rm -rf Standalone_Tests
#
	unlink $(CP_ROOT) 1>/dev/null 2>&1

$(CLEAN_STAMP): $(BASE_DIR)
	$(do_clean)
	touch $@

clean:
	-$(do_clean)
	-rm -f clib4.library # in case it exists

# It does not matter which c-library implementation is used for these:
$(INSPECT_EXE): inspect.c
	ppc-amigaos-gcc -mcrt=newlib -o $@ $< -Wall -Werror -pedantic -std=c11

$(DUMMY_EXE): dummy.c
	ppc-amigaos-gcc -mcrt=newlib -o $@ $< -Wall -Werror -pedantic -std=c11

do_clean=                                                                  \
	for TEST in $(tests) $(sa_tests) ;                                 \
	do                                                                 \
		$(MAKE) -C "$${TEST}" clean ;                              \
	done
