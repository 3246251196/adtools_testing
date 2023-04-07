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

Inside each artifact will be 4 binaries; clib, newlib (2) * dynamic, static (2). Along with those binaries with be a corresponding script, name prepended with "run_". Rather than executing the binary the script should be executed since it will handle the invocation of the binary and report back whether the test passed including automatic inspection tests. See below (section: Integration into the test framework) for more information.

## Important
This script/repo was written at the time when
- ADTOOLS last commit: 1501a4a26cf1bcffdd6dd4bcd603167a3e00f51b
- AFXGROUP CLIB2 last commit: ea6adcd010d760b65700036a8b800c38ce8cca1f

This is important wrt. to the "modifications" made above, since they may become out of date!

## Adding tests
### Standalone
Just create a directory under tests with a Makefile with an "all" target and a "clean" target. Variables are exported in the parent makefile (the one under tests, which include some useful variables if needed). A standalone test is shown in 99_rjd_standalone; the test framework will still build it for you.

### Integration into the test framework
Or, use the existing framework which "attempts" to make life easier. The only target required would be "$(PROG)". There is a makefile function "LOG_RUN" which enable automatic logging to an appropriately named file. Using this approach will also archive up the test executable and necessary dependent shared objects (in the case the SO are used) and log files and AmigaOS scripts into an LHA file which is ready to be transferred to the AmigaOne machine. The log files are useful to get verbose output from the linker phase, compiler phase and output of READELF.

Inspections can be added to tests by simply providing commented lines in the makefile of the test being added. See 1_rjd_test_example for an example. Also, see 0_rjd_simplest_example for the simplest example.

Lastly, since the testing framework runs all the building of the tests in parallel, it is important to rename any test specific artifacts - such as relocatable object files, archives files or shared objects - with a unique name. This allows parallel builds where the same files are not being incorrectly linked with or added to the incorrect archive. See 2_capehill_adtools_issue_139_test_code for an example of how to name any specific test artifacts using the already provided FILE_INFIX variable. Recall that for every test there are 4 dimensions as described above (newlib,clib * dynamic,static) running in parallel which is also running in parellel with every other test case. The test framework handles contention everywhere else using this exact approach.
