# adtools_testing

Run the script "./4afx".

This will checkout ADTOOLS building GCC 11 and BINUTILS 2.23.2 using AFXGROUP's CLIB2.
It also makes the following modifications:
- Copies over the AMIGAOS.H file from AFXGROUP's CLIB2 to the GCC rs6000 (linker script);
- Currently hacks out -Werror in AFXGROUP's CLIB2 due to an issue with timeval cast;
- Forces the creation of AFXGROUP'S CLIB2 shared libraries;

After building the CROSS COMPILER, the script will then run all of the tests in the "tests" folder.
