// reading a text file
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
using namespace std;

int main ()
{
  double i,j,k;
  string line;
  string type;
  ifstream myfile("problem1.txt");  
  if (myfile.is_open())
    {
      while (getline(myfile,line))
	{
	  istringstream row1(line);
	  row1 >> type >> i >> j >> k;
	  cout << type << ' ' << i << ' ' << j << ' ' << k << endl;
	}
    }
  else cout << "Unable to open file"; 
  myfile.close();
  return 0;
}
  
