/* The test framework is unforgiving in its approach; it will ALWAYS
   perform 6 dimensions of test: The set of { NEWLIB, CLIB2, CLIB4 } * {
   STATIC, DYNAMIC }.  In some cases, a test may only be interested in a
   subset of that cross product. For example, a test may only care about
   DYNAMIC. For the static build of each C-library of the test, we just
   tell the framework to use this dummy executable that purposefully
   returns the code 21. This code is then understood by the run scripts
   to represent a "DUMMY TEST" that just passes */

int main(int argc, char *argv[])
{
  (void)argc;
  (void)argv;
  return 21;
}
