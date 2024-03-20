extern void someExternFn( void );

int add42( int x )
{
  someExternFn();

  return x+42;
}
