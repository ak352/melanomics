#include<map>
#include<fstream>
#include<iostream>
#include<sstream>
#include<string>

using namespace std;

#define HMILLION 100000000

int main(int argc, char * argv[])
{
  map<int,int> histogram;
  ifstream fid;
  fid.open(argv[1], ifstream::binary);
  int lines = 0;
  int length = 1<<22;

  while(fid.good())
    {
      char * buffer = new char[length];
      string line;
      int num;
      getline(fid, line);
      istringstream ss(line);
      ss >> num;
      if(histogram.find(num)==histogram.end())
	histogram[num] = 0;
      histogram[num] += 1;
      lines++;
      if(lines % HMILLION == 0)
	cerr << lines << " lines processed." << endl;

    }

  
  for(map<int,int>::iterator it=histogram.begin(); it!=histogram.end(); it++)
    cout << it->first << "\t" << it->second << endl;
}

