# adtools_testing

## Using this repository
### Ideal scenario (TL;DR)
It should be as easy is the following steps:
- ./adt -b (if you want to build a cross compiler)
- ./adt -t (if you want to run tests using that cross compiler)
- copy the adt_tests.lha to the AmigaOne machine
- lha x adt_tests.lha
- execute run_all_script, OR,
- cd into the specific test case variant of interest and invoke
  "execute run_*.script", OR,
- run the executable directly, yourself (you may need to make
  clib4.library available to the LIBS: assign manually if you run it
  yourself versus using the user.script)
- ./adt -c will then clean out the tests directory, recursively

### Goal
At the heart of it, this script does two things:
- Builds ADTOOLS in-place,
- And/Or, builds the tests in this repository ready for execution on an
  AmigaOne.

It acts like a CHROOT almost in the sense that everything is performed
at the location of where this repository, "adtools_testing", is
cloned. Nothing in your environment is molested outside of the location
from where you have cloned this respoistory. It is meant to enable the
rapid development and testing of ADTOOLS. Hopefully, a lot of the
laborious work has been wrapped up in the scripts and makefiles
contained herein but it is completely capable of using an already
existing version of ADTOOLS on your machine versus building or using the
in-place version if desired.

The usage of the "adt" script can be seen by merely invoking "./adt".

With regards to building the tests, the "adt" script will create an
artifact named "\<PREFIX>adt_tests.lha". This file can be sent to your
AmigaOne machine and extracted. The extraction will cause the creation
of a folder named "tests" and a script (without executable permissions)
named "run_all.script" which can be invoked with "execute
run_all.script" on the AmigaOne machine.  "run_all.script" will finalise
the unpacking of the tests and automatically invoke "user.script" on
each test case variant. By default, the "user.script" will execute each
test variant. Be aware that testing incurs the risk of crashing your
machine! For each test there are 6 variants: 3 variants of c library
version (newlib, clib2 and clib4) and 2 variants of link type (dynamic
and static). In the case of Shared Object creation, the test framework
will copy any necessary SO files into the directory for that variant
(Note: If your test creates a Shared Object and the executable needs
that Shared Object then the test framework will automatically copy that
into the LHA file. But, if your test relies on some non
compiler/C-LIBRARY Shared Object that you installed into the SDK path
(CROSS_PREFIX) - such as libpng.so that is installed into
/sdk/newlib/lib/libpng.so then that file will not be added. Only
compiler/C-LIBRARY Shared Objects in the CROSS_PREFIX are copied. You
would have to manually copy such a Shared Object into the test
directory). The ELF.LIBRARY will load local SO files in preference. For
each executable binary, if the required Shared Object cannot be found in
either the current test directory or the installed location of the
ADTOOLS cross compiler, no warning will be issued. No Amiga Shared
Libraries are sought and added to the LHA for that test variant;
instead, it is expected that those Shared Libraries will exist on the
AmigaOne machine invoking the test. The only exception to this is
"clib4.library"; the test framework shall also add the "clib4.library"
to the final LHA file, "\<PREFIX>adt_tests.lha". It does this be
searching two locations and taking the first one it finds. Firstly, the
assumption is that the used compiler is one built by this script, so the
clib4.library is searched for in the cloned location of the ADTOOLS
repository, i.e. the source code. The reason for this is that it may be
that you are modifying the clib4 source code but not invoking "make
install". The fallback location is the CROSS_PREFIX which is set by the
framework is essentially the installation directory of the cross
compiler SDK.

It should be understood that some tests may fail to build for differently
configured cross-compilers. This is not necessarily a failure. For example,
there may be tests that can only be built using GCC 11. In the event of a
failure, simply inspect the log file for that variant. See further below -
"Integration into the test framework" - for ways to build dummy executables if
build failures for particular environments should be avoided.

The script named "run_*.script" executes the test executable, records
the STDOUT and STDERR, compares STDOUT to an expected set of results and
reports the result as:
- PASS    (there was no difference),
- PARTIAL (there was a difference but only in order; this can be useful
          for multi threaded tests where some threads may report output
          before the other thread without prediction),
- FAIL    (there was a difference in content),
- ERROR (the inspection executable, whose source code is in this
          repository, unexpectedly failed).

## Prefixes
### Example of testing multiple compilers
The usage complexity of this script can go from simple to complex. You
can supply prefix options to the script. This allows for checking out
and building multiple cross-compilers for modification and for
testing. For example, you may want to build a cross compiler using GCC
10, SDK 53.30. The script allows you the option to do that by providing
a prefix option. Basically, this prefixes the necessary files/folders
with the prefix name. You may want to invoke something like "-p
gcc10_sdk53_expClib". You can then build cross compiler and tests for
that prefix so long as you supply the prefix option for each build and
test action. You can then do the same for a different combination, such
as GCC 11 with classic CLIB2.

### Deviation to self-contained cross compiler installation
In addition to prefixing is the ability to deviate from the principles
of this script. You can install the cross compiler outside of the
directory which was used to clone this repository. The checkout of
ADTOOLS and all the source files for the cross compiler are still cloned
inside the cloned folder, but the "make install" of the cross compiler
is installed outside. This is similar to prefixing and not really
recommended.

### Previous build session cache
A number of options may be used to build a cross compiler. For example:
"./adt -b -e beta10 -s 53.30 -g 10" and it can become difficult to
remember those options. Indeed, they need to be remembered again if an
action should be performed in the context of that particular cross
compiler, such as building it again due to source file changes, or if
wanting to build the tests for that compiler. This script will store the
build sessions settings in a file. On the next invocation of the script
- whether building or testing, you can supply the "-x" option and the
script will parse the last build session's settings which saves the need
to remember all of the switches. Note, though, that once a new build
session is performed, the cache file gets written over, but it is backed
up. Alternatively, you can provide an option to avoid writing over the
previous cache.

## Adding tests
### SPE
See example "10_x_div_by_float_zero_wchar" for a possible approach to
building a test with SPE in mind. Currently, only GCC 6 can generate SPE
instructions.

### Integration into the test framework
Alternatively, use the existing framework which attempts to make life
easier. The only target required would be "$(PROG)". There is a makefile
function, "LOG_CMD", which enables automatic logging to an appropriately
named file. Using this approach will also archive up the test executable
and necessary, dependent Shared Objects (in the case the Shared Objects
are used) and log files and AmigaOS scripts into an LHA file which is
ready to be transferred to the AmigaOne machine. The log files are
useful to get verbose output from the compiler phase, linker phase,
output of READELF, needed Shared Objects and suspected required Shared
Libraries; suspected because the framework merely greps for a pattern of
"*.library" in the binary and assumes that the executable will try to
open that library.

The framework will always attempt to create 6 variants, as mentioned
above, but in some test cases the test may not care about a particular
variant. For instance, a test created using dlopen() may not not care
about any of the 2 static variants. In such a case, a DUMMY test can be
created for that situation. The framework builds a dummy binary adhering
to the naming convention that just returns a particular exit code that
the scripts know to mean a dummy test. Dummy tests always pass. An
example can be seen in "12_dlopen_binutils_test".

The most basic example of an integrated test can be found in
"0_rjd_simplest_example".

#### Automated inspections
Inspections can be added to tests by simply providing commented lines in
the makefile of the test being added. See "1_rjd_test_example" for an
example.

#### Naming generated outputs
Since the testing framework runs all the building of the tests in
parallel it is important to rename any test specific artifacts - such as
relocatable object files, archives files or shared objects - with a
unique name. This allows parallel builds where the same files are not
being incorrectly linked with or added to the incorrect archive. See
"2_capehill_adtools_issue_139_test_code" for an example of how to name
any specific test artifacts using the already provided "FILE_INFIX"
variable. Recall that for every test there are 6 dimensions as described
above (newlib,clibs * dynamic,static) running in parallel which is also
running in parallel with every other test case. The test framework
handles contention everywhere else using this exact approach.

### Standalone
In the case you just want to add a test without needing to follow the
test framework then you can add a standalone test. Just create a
directory under tests with a makefile with an "all" target and a "clean"
target. Variables are exported in the parent makefile (the one under
tests, which include some useful variables if needed). A standalone test
is shown in "99_rjd_standalone"; the test framework will still build it
for you.

The test framework will log all output to a file named log.txt inside
the test folder, but, this log file is primitive.

Standalone tests are also added to the final archive under the folder
named "Standalone_Tests".

Standalone tests do not have all 6 variants built. The test framework
invokes the "all" rule once. That will have to be handled manually, in
the makefile, if desired.

In various tests there may be a file named "sa.makefile". This file can
be used instead of the makefile in the case that there should also be an
option to run the test without using the test framework. This file must
be manually created. The file does not have to be called "sa.makefile",
it can be called whatever is desired, but that name is a general
guideline.

The test framework will never do anything with this file. It is just
useful for those that want to pull this repository down and run the
tests immediately in their own way.

#### Integration tests' user configurable variables
##### Deletion of files (variable: CLEAN_ME)
In the case you are integrating a test into the test framework and you
want to forcefully request certain files to be deleted when using ./adt
-c you can add a Makefile variable named CLEAN_ME with a list of file
that you want to delete. See test 13_constructor_destructor for an
example. By default, the testing framework will delete commonly
anticipated files, such as those that have an extension of .so or .o,
but there are always exceptions.

##### Mandatory depedencies (variable: NEED_DEP)
The framework checks for the existence, finally, of "$(PROG)". As stated
above, that is the only required rule. There can be situations where the
test may require the creation of a file as well as "$(PROG)". For
instance, a test that generates two separate executable files. Since the
framework is purposefully permissive in order to log as much information
as possible, its success check is merely the existence of "$(PROG)". By
adding files to the NEED_DEP variable, the framework will ensure that
"$(PROG)" and any of the files in "$(NEED_DEP)" exist, otherwise it will
consider it a fail.

##### Thread implementation (variable: THREAD_IMPL)
This variable is not really used internally, but it is worth
mentioning. We know about the -athread option. This specifies which
threading implementation to use. Normally, we use -athread=native to
specify that we want to use the AmigaOS4 native approach to
threading. See an example of its use in "1_rjd_test_example" and how it
defaults to native, but can be overridden. For instance, to build with
"pthread", i.e. -athread=pthread, you could issue the command "./adt -t
THREAD_IMPL=pthread".
