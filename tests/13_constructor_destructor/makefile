include ../common.mak

# Ask the testing framework to forcefully remove these files on an ADT script clean
CLEAN_ME=$(wildcard child_*)

CPPFLAGS+=-D__USE_INLINE__

# See:
# https://forum.hyperion-entertainment.com/viewtopic.php?f=26&t=4964
#
# Recommended:
# CFLAGS+=-O0 fno-aggressive-loop-optimizations

CHILD=child_$(FILE_INFIX)

$(CHILD): child.c
	$(call LOG_CMD,Link Child,$(CC) $(CPPFLAGS) -nostartfiles -o $@ $^ $(LDFLAGS))

$(PROG): loader.c $(CHILD) 
	$(call LOG_CMD,Link Loader/$(PROG),$(CC) $(CPPFLAGS) -o $@ $< $(LDFLAGS))
