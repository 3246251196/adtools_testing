CC=ppc-amigaos-gcc
CFLAGS_SPE=-mcpu=8540 -mtune=8540 -mspe -mabi=spe -mfloat-gprs=double
OBJECTS=A1222_SPE_floats.o

A1222_SPE_floats: $(OBJECTS)
	$(CC) $(OBJECTS) $(CFLAGS_SPE) -o A1222_SPE_floats

A1222_SPE_floats.o: A1222_SPE_floats.c
	$(CC) $(INCLUDES) $(CFLAGS_SPE) -c A1222_SPE_floats.c -o A1222_SPE_floats.o
