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
- AFXGROUP CLIB2 last commit: ea6adcd010d760b65700036a8b800c38ce8cca1f

This is important wrt. to the "modifications" made above, since they may become out of date!

To add a test:
Just create a directory under tests with a Makefile with an "all" target and a "clean" target. Variables are exported in the parent makefile (the one under tests, which include some useful variables if needed).

Or, use the existing framework which "attempts" to make life easier. The only target required would be "$(PROG)". See the test in directory "1" for an example. There are makefile functions "LOG_INF" and "LOG_RUN" which enable automatic logging to an appropriately named file. Using this approach will also archive up the test executable and necessary dependent shared objects (in the case the SO are used) and log files into an LHA file which is ready to be transferred to the AmigaOne machine and simply invoked. The log files are useful to get verbose output from the linker phase, compiler phase and output of READELF. The function "LOG_EXT" can be used to bung in extra information to the generated log file.
