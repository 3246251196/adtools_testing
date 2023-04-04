# adtools_testing

You should read and have a setup that is able to build ADTOOLS. See the ADTOOLS repo.

## Using this repository
### For more information
Run ./4afx [-h | --help]

### Running ./4afx should be all that is needed
Running 4afx will build the ADTOOLS repository and then generate all the tests with logging information and the necessary Shared Objects (where necessary) in a single compressed LHA file per test.

If the "build" directory already exists then 4afx assumes that ADTOOLS is already built and that only the tests should be regenerated. In the case that there was an issue during the build of ADTOOLS and you want to continue building, issue "./4afx build" which will continue the build and then stop without running the tests. In the case that build is not the first argument to the script, then all arguments are passed to the testing framework makefile.

By default, the script will consume all the available threads available on your machine. You can override this by setting a variables CORES to an amount you desire. For example, if you have 6 physical cores, and 12 logical cores, the script will consume all resources. You can, instead, supply CORES=4 to the environment if desired.

The general idea is that this repository / script builds ADTOOLS etc all restricted to the scope of the directory on your local machine where this repository is checked out. That is to say that it will not interfere with your environment outside; kind of like a CHROOT.

The steps are that it will checkout ADTOOLS building GCC 11 and BINUTILS 2.23.2 using AFXGROUP's CLIB2.
It also makes the following modifications (for now):
- Copies over the AMIGAOS.H file from AFXGROUP's CLIB2 to the GCC rs6000 (linker script);
- Currently hacks out -Werror in AFXGROUP's CLIB2 due to an issue with timeval cast;
- Forces the creation of AFXGROUP'S CLIB2 shared libraries;
- After building the CROSS COMPILER, the script will then run all of the tests in the "tests" folder.

### Artifacts
The artifacts of interest are the LHA files that are created in each test folder. They should be able to be transferred to your AmigaOne machine for immediate execution. In the case that the test require SHARED OBJECTS, they will be available in the LHA file, and since "elf.library" should look into the current working directory in preference, then they should be picked up there: standalone - without any affect of your environment on your cross compilation machine or AmigaOne machine.

The idea is to run the tests using newlib and clib2 combined with dynamic and static libraries, so, for any test, expect 4 final binaries / lha files which can then be extracted and the "EXE" file can be executed on the AmigaOne machine.

## Important
This script/repo was written at the time when
- ADTOOLS last commit: 1501a4a26cf1bcffdd6dd4bcd603167a3e00f51b
- AFXGROUP CLIB2 last commit: ea6adcd010d760b65700036a8b800c38ce8cca1f

This is important wrt. to the "modifications" made above, since they may become out of date!

## Adding tests
### Standalone
Just create a directory under tests with a Makefile with an "all" target and a "clean" target. Variables are exported in the parent makefile (the one under tests, which include some useful variables if needed).

### Integration into the test framework
Or, use the existing framework which "attempts" to make life easier. The only target required would be "$(PROG)". See the test in directory "1" for an example. There are makefile functions "LOG_INF" and "LOG_RUN" which enable automatic logging to an appropriately named file. Using this approach will also archive up the test executable and necessary dependent shared objects (in the case the SO are used) and log files into an LHA file which is ready to be transferred to the AmigaOne machine and simply invoked. The log files are useful to get verbose output from the linker phase, compiler phase and output of READELF. The function "LOG_EXT" can be used to bung in extra information to the generated log file.
