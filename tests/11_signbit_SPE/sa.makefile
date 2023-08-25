ifneq ($(shell uname),AmigaOS)
CC=ppc-amigaos-gcc
else
CC=gcc
endif

CFLAGS=-mspe -mcpu=8540 -mfloat-gprs=double -mabi=spe
LDFLAGS=-athread=native
LDLIBS=-lm

main: 
