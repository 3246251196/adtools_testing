int add42( int x )
{
  return x+42;
}

extern "C"
{
  int add42another( int x )
  {
    return x+42;
  }
}
