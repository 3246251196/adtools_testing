# -*- mode: makefile;-*-
ifeq ($(SCRIPT_INVOCATION),)
$(error This makefile should only be invoked by the "adt" script)
endif

# User modifiable variables (can be extended in the test's makefile):
#
# ===
# Any files in this variable are also added to $(FINAL_LHA)
#
# Another use case this variable is needed for is the following use case: when
# the program tests dlopen and therefore does not link to a library at link
# time, but opens it at runtime. It is likely that you will need to add the
# library (.so) file into this variable so that it is included in the LHA file.
#
# By default, all files matching the patterns below will be added to each
# variant; the source files and makefiles:
EXTRA_FILES=$(wildcard *.c *.h *.asm *.s *.S *.cpp *.hpp *.cxx *.hpp \
		*.hxx *makefile* *Makefile* *MAKEFILE* )
#
# ===
# Any files in here are also necessary (as well as the existence of $(PROG)) for
# a test to show itself as successful. The framework assumes that as long as
# $(PROG) exists - i.e. that an executable was finally generated - then the
# test/variant was successful. This is commonly the case, but not always the
# desire
NEED_DEP=
#
# ===
# The following is not really used in the framework, but it is worth mentioning
# it. In ADTOOLS we have an AmigaOS4 specific implementation of threading. The
# -athread option specifies which implementation should be used. For the longest
# time, this has been -athread=native: which is the native AmigaOS4
# implementation of threading. In the near future, we wish to finish off /
# extend -athread=posix/pthread. It can be an idea to use THREAD_IMPL and
# default it to "native" in your makefile:
# THREAD_IMPL=
#######

SHELL=/bin/bash
CWD=$(shell basename $$(pwd))
FILE_INFIX=test_$(CWD)_$(INFIX)

PROG=main_$(FILE_INFIX).exe
LOG_FILE=log_$(FILE_INFIX).txt
LHA_FILE=lha_$(FILE_INFIX).lha
RUN_TEST_SCRIPT=run_$(FILE_INFIX).script
INSPECT_EXPECTED=inspect_$(FILE_INFIX).expected
INSPECT_STDOUT=inspect_$(FILE_INFIX).stdout
INSPECT_STDERR=inspect_$(FILE_INFIX).stderr
INSPECT_EXE_FILE=inspect_$(FILE_INFIX)_$(INSPECT_EXE)
# We need this for parallel jobs otherwise the located libraries may become corrupt
TEMP_DIR=temp_$(FILE_INFIX).tmp

# A "function" which should be called from makefiles. The horrid SED
# stuff exists in the case that the actual command - itself - contains
# commas. Make is ruthless, a comma will mean that that is the end of
# the argument. This "function" allows wrapping an argument in double
# parens `(( ... ))' that can then include a comma. This is useful in
# the following case:
#
# $(call LOG_CMD, Final Linking of the Executable,(($(CC) $(LDFLAGS) -Wl,-Map=map.out)))
# Notice that the last argument contains a comma:
LOG_CMD = -echo "\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#"                              >> $(LOG_FILE) ;    \
	echo  "TIME STAMP                     : $$(date)"                               >> $(LOG_FILE) ;    \
	echo  "TARGET                         : $@$(3)"                                 >> $(LOG_FILE) ;    \
	echo  "PHASE                          : $(1)"                                   >> $(LOG_FILE) ;    \
	echo  "COMMAND                        : $$(echo '$(2)' | sed 's/^((\|))$$//g')" >> $(LOG_FILE) ;    \
	echo  "COMMAND OUTPUT (STDOUT/STDERR) : See following lines"                    >> $(LOG_FILE) ;    \
	echo "\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#"                                 >> $(LOG_FILE) ;    \
	$$(echo '$(2)' | sed 's/^((\|))$$//g')                                         1>> $(LOG_FILE) 2>&1

# Default rules that can be overridden
%.o: %.c
	$(call LOG_CMD,Compile Unit,$(CC) $(CFLAGS) -c -o $@ $<)
%.o: %.cpp
	$(call LOG_CMD,Compile Unit,$(CXX) $(CFLAGS) -c -o $@ $<)

# For test that do not care about a particular variant just provide a
# dummy test that passes.
#
# Unfortunately, we need to do some crazy patching due to double
# expansion. Once for the call and then again when the rule actually
# gets executed - otherwise, we lose the dollar signs; hence, the needed
# subst function
define DUMMY_TEST
DUMMY=1
$(PROG):
	echo "### MAKE: (Re)Built DUMMY test/variant \"$(FILE_INFIX)\" [$(1)]"
	$(subst $$,$$$$,$(call LOG_CMD,DUMMY_TEST,cp ../$(DUMMY_EXE) $(PROG),$(PROG) ($(DUMMY_EXE))))
endef

# Unfortunately, the compiler libraries for newlib are not in a folder
# named newlib. For example, libgcc.so is inside:
# "lib/gcc/ppc-amigaos/11.3.0/libgcc.so", unlike clib4 (or clib2) which
# is in clib4, as in: "lib/gcc/ppc-amigaos/11.3.0/clib4/libgcc.so".
# GREP_OPT_C_LIB is a hack to get around this. First, assume that for
# any library we are looking for, we will find it in a location that
# contains the string of the particular C library being used. Then, in
# the case that we are newlib, so long as we remove anything that
# contains "/clib4/", we assume that is the newlib library. This works
# for the case that newlib is in the string and is not.
GREP_OPT_C_LIB=$(C_LIB)
ifeq ($(C_LIB),newlib)
	GREP_OPT_C_LIB=-v '/clib2/\|/clib4/'
endif

.PHONY: clean all
all: $(LHA_FILE)
	# If it is a dummy test then we have already stated such
	if [[ -z "$(DUMMY)" ]] ;                                                                    \
	then                                                                                        \
		if [[ -f '$(PROG)' $(if $(NEED_DEP),$(foreach DEP,$(NEED_DEP),&& -f '$(DEP)')) ]] ; \
		then                                                                                \
			echo "### MAKE: (Re)Built test/variant       \"$(FILE_INFIX)\"" ;           \
		else                                                                                \
			echo "### MAKE: Failed to build test/variant \"$(FILE_INFIX)\"" ;           \
		fi ;                                                                                \
	fi

$(LHA_FILE): $(PROG) $(RUN_TEST_SCRIPT)
	mkdir -p $(TEMP_DIR)
ifneq ($(DYN),)
	$(call LOG_CMD,Listing Shared Objects,,)
	ARR_SO=($$($(READELF) -d $(PROG) 2>/dev/null | grep NEEDED | sed 's,.*\[\(.*\)\],\1,')) ; \
	for SO in $${ARR_SO[@]} ;                                                                 \
	do                                                                                        \
		LOC=$$(find ../$(CP_ROOT)/ -name "$${SO}"              |                          \
						grep $(GREP_OPT_C_LIB) |                          \
						grep "ppc-amigaos")    ;                          \
		if [[ -z "$${LOC}" ]] ;                                                           \
		then                                                                              \
			LOC=$$(find . -name "$${SO}") ;                                           \
			{ test -f "$${LOC}" && $(LHA_ADD) $@ "$${LOC}" &&                         \
				echo "Needed SO, \"$${SO}\" FOUND" >> $(LOG_FILE) ; } ||          \
				echo "Needed SO, \"$${SO}\" NOT FOUND" >> $(LOG_FILE) ;           \
		else                                                                              \
			{ test -f "$${LOC}" && cp "$${LOC}" $(TEMP_DIR) &&                        \
				echo "Needed SO, \"$${SO}\" FOUND" >> $(LOG_FILE) ; } ||          \
				echo "Needed SO, \"$${SO}\" NOT FOUND" >> $(LOG_FILE) ;           \
			cd $(TEMP_DIR) ;                                                          \
			$(LHA_ADD) ../$@ "$$(basename "$${LOC}")" ;                               \
			cd .. ;                                                                   \
		fi ;                                                                              \
	done
endif
	$(call LOG_CMD,Listing Shared Libraries,,)
	grep -a -o -E "[A-Za-z_0-9]+\.library" $(PROG) 2>/dev/null | sort -u >> $(LOG_FILE)
# Try to locate a clib4.library and add it to the LHA file. We take the one from
# $(ADTOOLS_DIR) because it may be the case that we are modifying and rebuilding
# clib4 source and it may be that we are not performing a make install on that
# rebuilt version which would prevent it from being updated in the
# $(ADTOOLS_BUILD) dir. In the case that lookup fails, we will fallback to using
# any clib4.library that is found in CP_ROOT.
ifeq ($(C_LIB),clib4)
# Short cut it if the file was already found and placed in ../clib4.library!
	if [[ ! -f ../clib4.library ]] ;                                                          \
	then                                                                                      \
		CLIB4_LIBRARY_LOC=$$(find $(BASE_DIR)/$(ADTOOLS_DIR)/native-build/downloads/clib4 \
					-name "clib4.library" 2>/dev/null || true ) ;             \
		if [[ -z $${CLIB4_LIBRARY_LOC} ]] ;                                               \
		then                                                                              \
			CLIB4_LIBRARY_LOC=$$(find $(CP_ROOT)                                      \
					-name "clib4.library" 2>/dev/null || true ) ;             \
		fi ;                                                                              \
	else                                                                                      \
		CLIB4_LIBRARY_LOC=../clib4.library ;                                              \
	fi ;                                                                                      \
	if [[ -n $${CLIB4_LIBRARY_LOC} ]] ;                                                       \
	then                                                                                      \
		cp $${CLIB4_LIBRARY_LOC} .. 2>/dev/null ;                                         \
		cp $${CLIB4_LIBRARY_LOC} . 2>/dev/null ;                                          \
		$(LHA_ADD) $@ clib4.library ;                                                     \
		rm -f $$(basename $${CLIB4_LIBRARY_LOC}) ;                                        \
	fi
endif
#
	cp ../$(INSPECT_EXE) $(INSPECT_EXE_FILE) # We know that the inspection exe is one level up.
	$(LHA_ADD) $@ $^ $(LOG_FILE) $(INSPECT_EXPECTED) $(INSPECT_EXE_FILE) $(EXTRA_FILES)
	rm -f $(INSPECT_EXE_FILE)
	rm -rf $(TEMP_DIR)

$(RUN_TEST_SCRIPT):
	echo "FAILAT 22" > $(RUN_TEST_SCRIPT) ;                                                                      \
	echo "$(PROG) > $(INSPECT_STDOUT) *> $(INSPECT_STDERR)" >> $(RUN_TEST_SCRIPT) ;                              \
	echo "IF \$${RC} EQ 21" >> $(RUN_TEST_SCRIPT) ;                                                              \
	echo "  ECHO \"'$(PROG)': Passed: DUMMY TEST\"" >> $(RUN_TEST_SCRIPT) ;                                      \
	echo "ELSE" >> $(RUN_TEST_SCRIPT) ;                                                                          \
	echo "  IF NOT \$${RC} EQ 0" >> $(RUN_TEST_SCRIPT) ;                                                         \
	echo "    ECHO \"'$(PROG)': Failed: Expected RETURN CODE 0\"" >> $(RUN_TEST_SCRIPT) ;                        \
	echo "  ELSE" >> $(RUN_TEST_SCRIPT) ;                                                                        \
	echo "    $(INSPECT_EXE_FILE) $(INSPECT_STDOUT) $(INSPECT_EXPECTED)" >> $(RUN_TEST_SCRIPT) ;                 \
	echo "    SET RET=\$${RC}" >> $(RUN_TEST_SCRIPT) ;                                                           \
	echo "    IF \$${RET} EQ 0" >> $(RUN_TEST_SCRIPT) ;                                                          \
	echo "      ECHO \"'$(PROG)': Passed\"" >> $(RUN_TEST_SCRIPT) ;                                              \
	echo "    ENDIF" >> $(RUN_TEST_SCRIPT) ;                                                                     \
	echo "    IF \$${RET} EQ 5" >> $(RUN_TEST_SCRIPT) ;                                                          \
	echo "      ECHO \"'$(PROG)': Partial: Same size, contents, but different order\"" >> $(RUN_TEST_SCRIPT) ;   \
	echo "      ECHO \"Inspect '$(INSPECT_STDOUT)' against '$(INSPECT_EXPECTED)'\"" >> $(RUN_TEST_SCRIPT) ;      \
	echo "    ENDIF" >> $(RUN_TEST_SCRIPT) ;                                                                     \
	echo "    IF \$${RET} EQ 10" >> $(RUN_TEST_SCRIPT) ;                                                         \
	echo "      ECHO \"'$(PROG)': Failed: Expected output did not match actual output\"" >> $(RUN_TEST_SCRIPT) ; \
	echo "      ECHO \"Inspect '$(INSPECT_STDOUT)' against '$(INSPECT_EXPECTED)'\"" >> $(RUN_TEST_SCRIPT) ;      \
	echo "    ENDIF" >> $(RUN_TEST_SCRIPT) ;                                                                     \
	echo "    IF \$${RET} EQ 20" >> $(RUN_TEST_SCRIPT) ;                                                         \
	echo "      ECHO \"'$(PROG)': Error: '$(INSPECT_EXE_FILE)' returned unexpectedly\"" >> $(RUN_TEST_SCRIPT) ;  \
	echo "    ENDIF" >> $(RUN_TEST_SCRIPT) ;                                                                     \
	echo "  ENDIF" >> $(RUN_TEST_SCRIPT) ;                                                                       \
	echo "ENDIF" >> $(RUN_TEST_SCRIPT)
	sed -n 's/^#@ \(.*\)/\1/p' $(firstword $(MAKEFILE_LIST)) > $(INSPECT_EXPECTED)

# Any test's Makefile can set a variable named CLEAN_ME to forcefully delete additional files
clean:
	-rm -rf *.o *.exe log*.txt *.a *.so *.lha *.map *.script *.expected $(TEMP_DIR) $(CLEAN_ME) 1>/dev/null 2>&1
