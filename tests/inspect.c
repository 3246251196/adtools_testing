/* rjd */
/* Inspection test for adt */
/* Two files are compared; STDOUT from the program and the expected file defined
   in the makefile. If the expected file is empty, the result is a PASS since
   this implies to inspection test was requested. If the size of the two files
   are different the result is FAIL. If the size is the same and the content and
   its order are the same the result is PASS. If the size is the same and the
   content is the same but in the wrong order, the results is PARTIAL. */
#include <stdio.h>
#include <stdlib.h>
#define ERR 20    /* shold never happen; an internal error */
#define FAIL 10   /* different content */
#define PARTIAL 5 /* same content, same size, but different order */
#define PASS 0    /* success */
int main(int argc, char *argv[])
{
  int res=PASS;
  FILE *actual=NULL,*expected=NULL;
  char *actual_contents=NULL,*expected_contents=NULL;
  long actual_size=-1,expected_size=-1;
  /* assuming any output will be ASCII characters 0-127 */
  int char_map[128]={0};
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
	  res=PASS; goto ENDER;
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
    if(!(actual_contents&&expected_contents))
      {
	res=ERR; goto ENDER;
      }
    if((1!=(long)fread(&actual_contents[0],actual_size,1,actual))||
       (1!=(long)fread(&expected_contents[0],expected_size,1,expected)))
      {
	res=ERR; goto ENDER;
      }
    for(;i<actual_size;i++)
      {
	char_map[(int)actual_contents[i]]++;
	char_map[(int)expected_contents[i]]--;
	if(actual_contents[i]!=expected_contents[i])
	  {
	    /* We have a mismatch. The contents may still be the same, though,
	       in a different order.  This can happen when threading occurs. We
	       use a different return code for this.  We are now AT LEAST a
	       PARTIAL */
	    res=PARTIAL;
	  }
      }
    i=0;
    for(;i<128;i++)
      {
	if(char_map[i]!=0)
	  {
	    res=FAIL; goto ENDER;
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

