ifeq ($(SCRIPT_INVOCATION),)
$(error This makefile should only be invoked by the "4afx" script)
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

LOG_RUN = echo "\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#" >> $(LOG_FILE) ;            \
	echo  "TARGET                         : $@" >> $(LOG_FILE) ;                  \
	echo  "PHASE                          : $(1)" >> $(LOG_FILE) ;                \
	echo  "COMMAND                        : $(2)" >> $(LOG_FILE) ;                \
	echo  "COMMAND OUTPUT (STDOUT/STDERR) : See following lines" >> $(LOG_FILE) ; \
	$(2) 1>> $(LOG_FILE) 2>&1

# Unfortunately, the compiler libraries for newlib are not in a folder
# named newlib. For example, libgcc.so is inside:
# "lib/gcc/ppc-amigaos/11.3.0/libgcc.so", unlike clib which is in
# clib2.  GREP_OPT is a hack to get around this. First, assume that
# for any library we are looking for, we will find it in a location
# that contains the string of the particular C library being
# used. Then, in the case that we are newlib, so long as we remove
# anything that contains "clib2", we assume that is the newlib
# library. This works for the case that newlib is in the string and is
# not.
GREP_OPT=$(C_LIB)
ifeq ($(C_LIB),newlib)
	GREP_OPT=-v clib2
endif

.PHONY: clean all
all: $(LHA_FILE)

$(LHA_FILE): $(PROG) $(RUN_TEST_SCRIPT)
ifneq ($(DYN),)
	ARR_SO=($$($(READELF) -d $(PROG) | grep NEEDED | sed 's,.*\[\(.*\)\],\1,')) ; \
	for SO in $${ARR_SO[@]} ;                                                     \
	do                                                                            \
		LOC=$$(find $${CROSS_PREFIX} -name "$${SO}" | grep $(GREP_OPT)) ;     \
		if [[ -z "$${LOC}" ]] ;                                               \
		then                                                                  \
			LOC=$$(find . -name "$${SO}") ;                               \
		fi ;                                                                  \
		test -f "$${LOC}" && cp "$${LOC}" . ;                                 \
		lha a $(LHA_FILE) "$$(basename "$${LOC}")" 1>/dev/null 2>&1 ;         \
	done
endif
	@cp ../$(INSPECT_EXE) $(INSPECT_EXE_FILE) # We know that the inspection exe is one level up.
	@lha a $(LHA_FILE) $(PROG) $(LOG_FILE) $(RUN_TEST_SCRIPT) $(INSPECT_EXPECTED) \
		$(INSPECT_EXE_FILE) *.map 1>/dev/null 2>&1
	@rm  $(INSPECT_EXE_FILE) # Doing this avoids getting warnings when extracting the LHAs on amiga

$(RUN_TEST_SCRIPT):
	@echo "$(PROG) > $(INSPECT_STDOUT) *> $(INSPECT_STDERR)" > $(RUN_TEST_SCRIPT) ;                           \
	echo  "IF NOT \`GET RC\` EQ 0" >> $(RUN_TEST_SCRIPT) ;                                                    \
	echo  "  ECHO \"$(PROG): Failed: Expected RETURN CODE 0\"" >> $(RUN_TEST_SCRIPT) ;                        \
	echo  "ELSE" >> $(RUN_TEST_SCRIPT) ;                                                                      \
	echo  "  $(INSPECT_EXE_FILE) $(INSPECT_STDOUT) $(INSPECT_EXPECTED)" >> $(RUN_TEST_SCRIPT) ;               \
	echo  "  IF NOT \`GET RC\` EQ 0" >> $(RUN_TEST_SCRIPT) ;                                                  \
	echo  "    ECHO \"$(PROG): Failed: Expected output did not match actual output\"" >> $(RUN_TEST_SCRIPT) ; \
	echo  "  ENDIF" >> $(RUN_TEST_SCRIPT) ;                                                                   \
	echo  "ENDIF" >> $(RUN_TEST_SCRIPT)
	@sed -n 's/^#@ \(.*\)/\1/p' $(firstword $(MAKEFILE_LIST)) > $(INSPECT_EXPECTED)

clean:
	@-rm -f *.o *.exe log*.txt *.a *.so *.lha *.map *.script *.expected 1>/dev/null 2>&1
