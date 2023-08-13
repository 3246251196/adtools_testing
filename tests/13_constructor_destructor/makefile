include ../common.mak

# Forcefully add the README.txt to the FINAL LHA file
EXTRA_FILES+=README.txt


# Ask the testing framework to forcefully remove these files on an ADT script clean
CLEAN_ME=$(wildcard child_*)

CPPFLAGS+=-D__USE_INLINE__

# See:
# https://forum.hyperion-entertainment.com/viewtopic.php?f=26&t=4964
#
# Recommended:
# CFLAGS+=-O0 fno-aggressive-loop-optimizations

CHILD=child_$(FILE_INFIX)

# Make the test framework recognise that this is a needed dependency
# and to fail if it does not exist.
#
# This test is kind of a special case. Normally, the goal is to just
# generate a single executable, $(PROG). But, here, we generate two
# seperate executables and we need both. In the case that $(CHILD) is
# not successfully created but $(PROG) is, then the framework sees the
# test as a success. Recall that the LOG_CMD function does not fail on
# bad return codes because we want to log everything! The framework
# assumes success if $(PROG) is built. We want to not succeed unless
# $(NEED_DEP) also exists as well as $(PROG)
NEED_DEP+=$(CHILD)

$(CHILD): child.c
	$(call LOG_CMD,Link Child,$(CC) $(CPPFLAGS) -nostartfiles -o $@ $^ $(LDFLAGS))

$(PROG): loader.c $(CHILD) 
	$(call LOG_CMD,Link Loader/$(PROG),$(CC) $(CPPFLAGS) -o $@ $< $(LDFLAGS))
