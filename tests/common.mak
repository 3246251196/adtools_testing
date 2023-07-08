ifeq ($(SCRIPT_INVOCATION),)
$(error This makefile should only be invoked by the "adt" script)
endif

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
MAP_FILE=$(PROG).map
TEMP_DIR=temp_$(FILE_INFIX).tmp # We need this for parallel jobs otherwise the located libraries may become corrupt

LOG_CMD = echo "\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#" >> $(LOG_FILE) ;            \
	echo  "TIME STAMP                     : $$(date)" >> $(LOG_FILE) ;            \
	echo  "TARGET                         : $@" >> $(LOG_FILE) ;                  \
	echo  "PHASE                          : $(1)" >> $(LOG_FILE) ;                \
	echo  "COMMAND                        : $(2)" >> $(LOG_FILE) ;                \
	echo  "COMMAND OUTPUT (STDOUT/STDERR) : See following lines" >> $(LOG_FILE) ; \
	echo "\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#" >> $(LOG_FILE) ;              \
	$(2) 1>> $(LOG_FILE) 2>&1 || exit 0

# Unfortunately, the compiler libraries for newlib are not in a folder
# named newlib. For example, libgcc.so is inside:
# "lib/gcc/ppc-amigaos/11.3.0/libgcc.so", unlike clib which is in
# clib2.  GREP_OPT_C_LIB is a hack to get around this. First, assume
# that for any library we are looking for, we will find it in a
# location that contains the string of the particular C library being
# used. Then, in the case that we are newlib, so long as we remove
# anything that contains "clib2", we assume that is the newlib
# library. This works for the case that newlib is in the string and is
# not.
GREP_OPT_C_LIB=$(C_LIB)
ifeq ($(C_LIB),newlib)
	GREP_OPT_C_LIB=-v clib2
endif
# We also want to restrict searches to those with "ppc-amigaos" in the
# path. This helps the situation where the build was installed using
# the -o option: for instance, the cross compiler may have been
# installed to /usr. When attempting to invoke FIND to figure out
# which Shared Object to add to the archive, we may match on non cross
# compiler objects! This is handled directly below.

.PHONY: clean all
all: $(LHA_FILE)
	if [[ ! -f $(PROG) ]] ;                                                                        \
	then                                                                                           \
		echo "    Failed to build test/variant \"$(PROG)\"" ;                                  \
	else                                                                                           \
		echo "    (Re)Built test/variant       \"$(PROG)\"" ;                                  \
	fi

$(LHA_FILE): $(PROG) $(RUN_TEST_SCRIPT)
	mkdir -p $(TEMP_DIR)
ifneq ($(DYN),)
	$(call LOG_CMD,Listing Shared Objects,,)
	ARR_SO=($$($(READELF) -d $(PROG) 2>/dev/null | grep NEEDED | sed 's,.*\[\(.*\)\],\1,')) ; \
	for SO in $${ARR_SO[@]} ;                                                                      \
	do                                                                                             \
		LOC=$$(find $${CROSS_PREFIX} -name "$${SO}"            |                               \
						grep $(GREP_OPT_C_LIB) |                               \
						grep "ppc-amigaos")    ;                               \
		if [[ -z "$${LOC}" ]] ;                                                                \
		then                                                                                   \
			LOC=$$(find . -name "$${SO}") ;                                                \
			{ test -f "$${LOC}" && $(LHA_ADD) $(LHA_FILE) "$${LOC}" &&                     \
				echo "Needed SO, \"$${SO}\" FOUND" >> $(LOG_FILE) ; } ||               \
				echo "Needed SO, \"$${SO}\" NOT FOUND" >> $(LOG_FILE) ;                \
		else                                                                                   \
			{ test -f "$${LOC}" && cp "$${LOC}" $(TEMP_DIR) &&                             \
				echo "Needed SO, \"$${SO}\" FOUND" >> $(LOG_FILE) ; } ||               \
				echo "Needed SO, \"$${SO}\" NOT FOUND" >> $(LOG_FILE) ;                \
			cd $(TEMP_DIR) ;                                                               \
			$(LHA_ADD) ../$(LHA_FILE) "$$(basename "$${LOC}")" ;                           \
			cd .. ;                                                                        \
		fi ;                                                                                   \
	done
endif
	$(call LOG_CMD,Listing Shared Libraries,,)
	grep -a -o -E "[A-Za-z_0-9]+\.library" $(PROG) 2>/dev/null | sort -u >> $(LOG_FILE)

	cp ../$(INSPECT_EXE) $(INSPECT_EXE_FILE) # We know that the inspection exe is one level up.
	$(LHA_ADD) $(LHA_FILE) $(PROG) $(LOG_FILE) $(RUN_TEST_SCRIPT) $(INSPECT_EXPECTED) \
		$(INSPECT_EXE_FILE) $(MAP_FILE)
	rm -f $(INSPECT_EXE_FILE)
	rm -rf $(TEMP_DIR)

$(RUN_TEST_SCRIPT):
	echo "FAILAT 21" > $(RUN_TEST_SCRIPT) ;                                                                    \
	echo "$(PROG) > $(INSPECT_STDOUT) *> $(INSPECT_STDERR)" >> $(RUN_TEST_SCRIPT) ;                            \
	echo "IF NOT \$${RC} EQ 0" >> $(RUN_TEST_SCRIPT) ;                                                         \
	echo "  ECHO \"'$(PROG)': Failed: Expected RETURN CODE 0\"" >> $(RUN_TEST_SCRIPT) ;                        \
	echo "ELSE" >> $(RUN_TEST_SCRIPT) ;                                                                        \
	echo "  $(INSPECT_EXE_FILE) $(INSPECT_STDOUT) $(INSPECT_EXPECTED)" >> $(RUN_TEST_SCRIPT) ;                 \
	echo "  SET RET=\$${RC}" >> $(RUN_TEST_SCRIPT) ;                                                           \
	echo "  IF \$${RET} EQ 0" >> $(RUN_TEST_SCRIPT) ;                                                          \
	echo "    ECHO \"'$(PROG)': Passed\"" >> $(RUN_TEST_SCRIPT) ;                                              \
	echo "  ENDIF" >> $(RUN_TEST_SCRIPT) ;                                                                     \
	echo "  IF \$${RET} EQ 5" >> $(RUN_TEST_SCRIPT) ;                                                          \
	echo "    ECHO \"'$(PROG)': Partial: Same size, contents, but different order\"" >> $(RUN_TEST_SCRIPT) ;   \
	echo "    ECHO \"Inspect '$(INSPECT_STDOUT)' against '$(INSPECT_EXPECTED)'\"" >> $(RUN_TEST_SCRIPT) ;      \
	echo "  ENDIF" >> $(RUN_TEST_SCRIPT) ;                                                                     \
	echo "  IF \$${RET} EQ 10" >> $(RUN_TEST_SCRIPT) ;                                                         \
	echo "    ECHO \"'$(PROG)': Failed: Expected output did not match actual output\"" >> $(RUN_TEST_SCRIPT) ; \
	echo "    ECHO \"Inspect '$(INSPECT_STDOUT)' against '$(INSPECT_EXPECTED)'\"" >> $(RUN_TEST_SCRIPT) ;      \
	echo "  ENDIF" >> $(RUN_TEST_SCRIPT) ;                                                                     \
	echo "  IF \$${RET} EQ 20" >> $(RUN_TEST_SCRIPT) ;                                                         \
	echo "    ECHO \"'$(PROG)': Error: '$(INSPECT_EXE_FILE)' returned unexpectedly\"" >> $(RUN_TEST_SCRIPT) ;  \
	echo "  ENDIF" >> $(RUN_TEST_SCRIPT) ;                                                                     \
	echo "ENDIF" >> $(RUN_TEST_SCRIPT)
	sed -n 's/^#@ \(.*\)/\1/p' $(firstword $(MAKEFILE_LIST)) > $(INSPECT_EXPECTED)

clean:
	-rm -rf *.o *.exe log*.txt *.a *.so *.lha *.map *.script *.expected $(TEMP_DIR) 1>/dev/null 2>&1
