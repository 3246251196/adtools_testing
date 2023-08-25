ifneq ($(shell uname),AmigaOS)
CC=ppc-amigaos-gcc
else
CC=gcc
endif

SOs=libcat.so libdog.so

dlopen_sample:  dlopen_sample.c $(SOs)
	$(CC) -o $@ $<

libcat.so: cat.c
	$(CC) -shared -fPIC $< $(CFLAGS) -o $@

libdog.so: dog.c
	$(CC) -shared -fPIC $< $(CFLAGS) -o $@
