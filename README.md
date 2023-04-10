# adtools_testing

## Using this repository
### For more information
Run "./adt"

The script is designed to do two things:
- Build ADTOOLS (GCC 11, BINUTILS 2.23.2 and use AFXGROUP's CLIB) after making some modifications that can be specified
- Run the tests in this repository either using the newly built ADTOOLS, or using your own ADTOOLS somewhere else

Whatever is inside adtools_mod is executed before building ADTOOLS. At the moment, this is needed to apply necessary changes after cloning ADTOOLS and can further modified if required.

When running the tests, the script will do just, finally creating an artifact: "adt_tests.lha". This file can be sent to your AmigaOne machine and extracted. The extraction will cause a folder named "tests" and a script named "run_all.script" (see that script inside "tests") which is designed to be run with "execute" on the AmigaOne machine. Said script will finalise the unpacking of the tests and automatically invoke "user.script" (see that script inside "tests") on each test case variant. By default, the script is commented out but can be modified. Each variant is standalone and for each test there are 4 variants; 2 variants of c library version (newlib and clib2) and 2 variants of link type (dynamic and static). In the case of Shared Object creation, the test framework will copy any necessary SO files into the directory for that variant. The ELF.LIBRARY will load local SO files in preference.

Ideally it should be as easy is the following steps:
- ./adt -b
- ./adt -t
- (copy the adt_tests.lha to the AmigaOne machine)
- lha x adt_tests.lha
- execute run_all_script

By default, the script will cause the make system to consume all the available threads available on your machine. You can override this by setting a variables CORES to an amount you desire. For example, if you have 6 physical cores, and 12 logical cores, the script will consume all resources. You can, instead, supply CORES=4 to the environment if desired.

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

Lastly, since the testing framework runs all the building of the tests in parallel, it is important to rename any test specific artifacts - such as relocatable object files, archives files or shared objects - with a unique name. This allows parallel builds where the same files are not being incorrectly linked with or added to the incorrect archive. See 2_capehill_adtools_issue_139_test_code for an example of how to name any specific test artifacts using the already provided FILE_INFIX variable. Recall that for every test there are 4 dimensions as described above (newlib,clib * dynamic,static) running in parallel which is also running in parallel with every other test case. The test framework handles contention everywhere else using this exact approach.
