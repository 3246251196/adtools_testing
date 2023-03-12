# adtools_testing

You should read and have a setup that is able to build ADTOOLS. See the ADTOOLS repo.

Run the script "./4afx".

This will checkout ADTOOLS building GCC 11 and BINUTILS 2.23.2 using AFXGROUP's CLIB2.
It also makes the following modifications:
- Copies over the AMIGAOS.H file from AFXGROUP's CLIB2 to the GCC rs6000 (linker script);
- Currently hacks out -Werror in AFXGROUP's CLIB2 due to an issue with timeval cast;
- Forces the creation of AFXGROUP'S CLIB2 shared libraries;

After building the CROSS COMPILER, the script will then run all of the tests in the "tests" folder.
Visit the log*.txt files to look at the verbose logging for COMPILER/LINK phase and also a generated output of readelf.

Important:
This script/repo was written at the time when
- ADTOOLS last commit: 1501a4a26cf1bcffdd6dd4bcd603167a3e00f51b
- AFXGROUP CLIB2 commit: ea6adcd010d760b65700036a8b800c38ce8cca1f
This is important wrt. to the "modifications" made above, since they may become out of date!
