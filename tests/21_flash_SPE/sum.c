int sum(float,float,float);
void driver( void )
{
    double x,y,z,result;

    x = 1.0f;
    y = 1.0f;
    z = 1.0f;

    result = sum (x,y,z);
}
int sum( float a, float b, float c)
{
    return a + b + c;
}
