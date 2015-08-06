#include<iostream>
#include<fstream>
#include<sstream>
#include<string>

using namespace std;




int main(int argc, char * argv[])
{
  ifstream fid;
  string fname(argv[1]);
  fid.open(fname.c_str(), ios::in);
  string line;
  int num = 0;
  while(fid.good())
    {
      getline(fid, line);
      istringstream ss(line);
      string chrom, pos;
      ss >> chrom >> pos;
      if(chrom==argv[2] && pos==argv[3])
	cout << line << endl;
      num++;
      if(num%10000000 == 0)
	cerr << num << " lines processed.." << endl;
    }
   
  

}
