# adtools_testing

## Using this repository
### For more information
Run "./adt"

At the heart of it, this script does two things:
- Builds ADTOOLS in-place,
- And/Or, builds the tests in this repository ready for execution on an
  AmigaOne.

It acts like a CHROOT almost in the sense that everything is performed at the
location of where this repository, "adtools_testing", is cloned. Nothing in your
environment is molested since everything is initiated from the process of the
script "adt". It is meant to enable the rapid development and testing of
ADTOOLS. Hopefully, a lot of the laborious work has been wrapped up in the
scripts and makefiles contained herein but it is completely capable of using an
already existing version of ADTOOLS on your machine versus building or using the
in-place version if desired.

The usage of the "adt" script can be seen by merely invoking "./adt".

With regards to building the tests, the "adt" script will create an artifact
named "adt_tests.lha". This file can be sent to your AmigaOne machine and
extracted. The extraction will cause the creation of a folder named "tests" and
a script (without executable permissions) named "run_all.script" which can be
invoked with "execute run_all.script" on the AmigaOne machine. "run_all.script"
will finalise the unpacking of the tests and automatically invoke "user.script"
(see that script inside "tests") on each test case variant. By default, the
actions of the "user.script" are commented out but this can be modified. Each
variant is standalone and for each test there are 4 variants; 2 variants of c
library version (newlib and clib2) and 2 variants of link type (dynamic and
static). In the case of Shared Object creation, the test framework will copy any
necessary SO files into the directory for that variant. The ELF.LIBRARY will
load local SO files in preference. For each executable binary, if the required
Shared Object cannot be found in either the current test directory or the
installed location of the ADTOOLS cross compiler, no warning will be issued. No
Amiga Shared Libraries are sought and added to the LHA for that test variant;
instead, it is expected that those Shared Libraries will exist on the AmigaOne
machine invoking the test.

The script named "run_<test case variant name>.script" executes the test
executable, records the STDOUT and STDERR, compares STDOUT to an expected set of
results and reports the result as:
- PASS    (there was no difference),
- PARTIAL (there was a difference but only in order; this can be useful for
          multi threaded tests where some threads may report output before the
          other thread without prediction),
- FAIL    (there was a difference in order or content),
- ERROR   (the inspection executable, whose source code is in this repository,
          unexpectedly failed).

### Ideal scenario
It should be as easy is the following steps:
- ./adt -b
- ./adt -t
- (copy the adt_tests.lha to the AmigaOne machine)
- lha x adt_tests.lha 
- execute run_all_script, OR,
- cd into the specific test case variant of interest and invoke
  "execute run_<test case variant name>.script", OR,
- run the executable directly, yourself.

## FYI
This script/repo was written at the time when
- ADTOOLS last commit: 1501a4a26cf1bcffdd6dd4bcd603167a3e00f51b

## Adding tests
### Standalone
Just create a directory under tests with a makefile with an "all" target and a
"clean" target. Variables are exported in the parent makefile (the one under
tests, which include some useful variables if needed). A standalone test is
shown in 99_rjd_standalone; the test framework will still build it for you.

### Integration into the test framework
Or, use the existing framework which "attempts" to make life easier. The only
target required would be "$(PROG)". There is a makefile function "LOG_CMD" which
enable automatic logging to an appropriately named file. Using this approach
will also archive up the test executable and necessary dependent shared objects
(in the case the SO are used) and log files and AmigaOS scripts into an LHA file
which is ready to be transferred to the AmigaOne machine. The log files are
useful to get verbose output from the linker phase, compiler phase and output of
READELF.

Inspections can be added to tests by simply providing commented lines in the
makefile of the test being added. See "1_rjd_test_example" for an example. Also,
see "0_rjd_simplest_example" for the simplest example.

Since the testing framework runs all the building of the tests in parallel, it
is important to rename any test specific artifacts - such as relocatable object
files, archives files or shared objects - with a unique name. This allows
parallel builds where the same files are not being incorrectly linked with or
added to the incorrect archive. See "2_capehill_adtools_issue_139_test_code" for
an example of how to name any specific test artifacts using the already provided
FILE_INFIX variable. Recall that for every test there are 4 dimensions as
described above (newlib,clib * dynamic,static) running in parallel which is also
running in parallel with every other test case. The test framework handles
contention everywhere else using this exact approach.
