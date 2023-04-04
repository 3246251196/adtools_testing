#include <iostream>
#include <vector>

int main(int argc, char *argv[])
{
  std::vector<float> v_f = {2.0f, 3.0f, 5.0f, 7.0f};
  for(auto e:v_f)
    std::cout << e << std::endl;
  
  return 0;
}
