/* rjd */
/* Inspection test for 4afx */
/* Two files are provided as input and their contents must be identical*/
/* This includes case */
/* We use asserts because we ASSERT this program should only be used as a tool for 4afx */
/*
As mentioned in the rule for creating this binary:
# TODO: Use a tool that is available to AmigaOS4 base package to actual lines. ARREX?
#       Not everyone has the SDK installed, so DIFF is not always available!
*/
#include <stdio.h>
#include <stdlib.h>
#define ERR 20
#define FAIL 5
#define SUCC 0
int main(int argc, char *argv[])
{
  int res=SUCC;
  FILE *actual=NULL,*expected=NULL;
  char *actual_contents=NULL,*expected_contents=NULL;
  long actual_size=-1,expected_size=-1;
  if(argc!=3)
    {
      res=ERR; goto ENDER;
    }
  if(!((actual=fopen(argv[1],"r"))&&(expected=fopen(argv[2],"r"))))
    {
      res=ERR; goto ENDER;
    }
  if(fseek(actual,0L,SEEK_END)||fseek(expected,0L,SEEK_END))
    {
      res=ERR; goto ENDER;
    }
  else
    {
      expected_size=ftell(expected);
      if(0L==expected_size)
	{
	  /* This must not be an inspection test! */
	  res=SUCC; goto ENDER;
	}
      actual_size=ftell(actual);
      if(actual_size!=expected_size)
	{
	  res=FAIL; goto ENDER;
	}
      rewind(actual);
      rewind(expected);
    }
  {
    int i=0;
    actual_contents=(char*)malloc(actual_size);
    expected_contents=(char*)malloc(expected_size);
    if((1!=(long)fread(&actual_contents[0],actual_size,1,actual))||
       (1!=(long)fread(&expected_contents[0],expected_size,1,expected)))
      {
	res=ERR; goto ENDER;
      }
    for(;i<actual_size;i++)
      {
	    printf("comparing: %c with %c\n",actual_contents[i],expected_contents[i]);
	if(actual_contents[i]!=expected_contents[i])
	  {
	    res = FAIL; goto ENDER;
	  }
      }
  }
 ENDER:
  if(actual) fclose(actual);
  if(expected) fclose(expected);
  if(actual_contents) free(actual_contents);
  if(expected_contents) free(expected_contents);
  return res;
}

