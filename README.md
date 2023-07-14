# adtools_testing

## Using this repository
### For more information
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
named "\<PREFIX>adt_tests.lha". This file can be sent to your AmigaOne machine
and extracted. The extraction will cause the creation of a folder named "tests"
and a script (without executable permissions) named "run_all.script" which can
be invoked with "execute run_all.script" on the AmigaOne machine.
"run_all.script" will finalise the unpacking of the tests and automatically
invoke "user.script" on each test case variant. By default, the "user.script"
will execute each test variant. Be aware that testing incurs the risk of
crashing your machine! Each variant is standalone and for each test there are 4
variants; 2 variants of c library version (newlib and clib2) and 2 variants of
link type (dynamic and static). In the case of Shared Object creation, the test
framework will copy any necessary SO files into the directory for that variant
(Note: If your test creates a Shared Object and the executable needs that Shared
Object then the test framework will automatically copy that into the LHA
file. But, if your test relies on some non compiler/C-LIBRARY Shared Object that
you installed into the SDK path (CROSS_PREFIX) - such as libpng.so that is
installed into /sdk/newlib/lib/libpng.so then that file will not be added. Only
compiler/C-LIBRARY Shared Objects in the CROSS_PREFIX are copied. You would have
to manually copy such a Shared Object into the test directory). The ELF.LIBRARY
will load local SO files in preference. For each executable binary, if the
required Shared Object cannot be found in either the current test directory or
the installed location of the ADTOOLS cross compiler, no warning will be
issued. No Amiga Shared Libraries are sought and added to the LHA for that test
variant; instead, it is expected that those Shared Libraries will exist on the
AmigaOne machine invoking the test. The only exception to this is
"clib2.library"; in the case that the build is using the experimental CLIB2
branch and that branch uses the shared library version of CLIB2 then then test
framework shall also add the "clib2.library" to the final LHA file,
"\<PREFIX>adt_tests.lha" and the "user.script" will perform some changes to your
Amiga's LIBS: assign JUST when performing the test. It will then put back the
original value of your LIBS: assign. This means that for tests that use such a
CLIB2 version, you do not need to worry about manually copying over the
necessary "clib2.library" into your LIBS: assign. This must be done manually,
or, the clib2.library must exist in LIBS: if you decide to run the tests
manually.

The script named "run_*.script" executes the test
executable, records the STDOUT and STDERR, compares STDOUT to an expected set of
results and reports the result as:
- PASS    (there was no difference),
- PARTIAL (there was a difference but only in order; this can be useful for
          multi threaded tests where some threads may report output before the
          other thread without prediction),
- FAIL    (there was a difference in content),
- ERROR   (the inspection executable, whose source code is in this repository,
          unexpectedly failed).

### Ideal scenario
It should be as easy is the following steps:
- ./adt -b
- ./adt -t
- copy the adt_tests.lha to the AmigaOne machine
- lha x adt_tests.lha 
- execute run_all_script, OR,
- cd into the specific test case variant of interest and invoke
  "execute run_*.script", OR,
- run the executable directly, yourself (you may need to make clib2.library
  available to the LIBS: assign manually if you run it yourself versus using
  the user.script)

## Prefixes
### Example of testing multiple compilers
The usage complexity of this script can go from simple to complex. You can
supply prefix options to the script. This allows for checking out and building
multiple cross-compilers for modification and for testing. For example, you may
want to build a cross compiler using GCC 10, SDK 53.30 with a particular
experimental CLIB2 branch. The script allows you the option to do that by
providing a prefix option. Basically, this prefixes the necessary files/folders
with the prefix name. You may want to invoke something like "-p
gcc10_sdk53_expClib". You can then build cross compiler and tests for that
prefix so long as you supply the prefix option for each build and test
action. You can then do the same for a different combination, such as GCC 11
with classic CLIB2.

### Deviation to self-contained cross compiler installation
In addition to prefixing is the ability to deviate from the
principles of this script. You can install the cross compiler outside of the
directory which was used to clone this repository. The checkout of ADTOOLS and
all the source files for the cross compiler are still cloned inside the cloned
folder, but the "make install" of the cross compiler is installed outside. This
is similar to prefixing and not really recommended.

### Previous build session cache
A number of options may be used to build a cross compiler. For example: "./adt
-b -e beta10 -s 53.30 -g 10" and it can become difficult to remember those
options. Indeed, they need to be remembered again if an action should be
performed in the context of that particular cross compiler, such as building it
again due to source file changes, or if wanting to build the tests for that
compiler. This script will store the build sessions settings in a file. On the
next invocation of the script - whether building or testing, you can supply the
"-x" option and the script will parse the last build session's settings which
saves the need to remember all of the switches. Note, though, that once a new
build session is performed, the cache file gets written over, but it is backed
up. Alternatively, you can provide an option to avoid writing over the previous
cache.

## FYI
This repo was developed at the time when the last commit to ADTOOLS was
"1501a4a26cf1bcffdd6dd4bcd603167a3e00f51b".

## Adding tests
### Standalone
Just create a directory under tests with a makefile with an "all" target and a
"clean" target. Variables are exported in the parent makefile (the one under
tests, which include some useful variables if needed). A standalone test is
shown in "99_rjd_standalone"; the test framework will still build it for you.

### Integration into the test framework
Alternatively, use the existing framework which attempts to make life
easier. The only target required would be "$(PROG)". There is a makefile
function, "LOG_CMD", which enables automatic logging to an appropriately named
file. Using this approach will also archive up the test executable and
necessary, dependent Shared Objects (in the case the Shared Objects are used)
and log files and AmigaOS scripts into an LHA file which is ready to be
transferred to the AmigaOne machine. The log files are useful to get verbose
output from the compiler phase, linker phase, output of READELF, needed Shared
Objects and suspected required Shared Libraries; suspected because the framework
merely greps for a pattern of "*.library" in the binary and assumes that the
executable will try to open that library.

Inspections can be added to tests by simply providing commented lines in the
makefile of the test being added. See "1_rjd_test_example" for an example. Also,
see "0_rjd_simplest_example" for the simplest example.

Since the testing framework runs all the building of the tests in parallel it is
important to rename any test specific artifacts - such as relocatable object
files, archives files or shared objects - with a unique name. This allows
parallel builds where the same files are not being incorrectly linked with or
added to the incorrect archive. See "2_capehill_adtools_issue_139_test_code" for
an example of how to name any specific test artifacts using the already provided
"FILE_INFIX" variable. Recall that for every test there are 4 dimensions as
described above (newlib,clib * dynamic,static) running in parallel which is also
running in parallel with every other test case. The test framework handles
contention everywhere else using this exact approach.
