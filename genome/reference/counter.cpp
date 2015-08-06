#include<iostream>
#include<string>
#include<vector>
#include<fstream>

using namespace std;
typedef vector<int> vi;

void count_line(const string &line, vi &counts)
{
  for(int k = 0; k < line.length(); k++)
    counts[(int)line[k]]++;
}

void print(const vi &vec)
{
  for(int k = 0; k < vec.size(); k++)
    cout << (char)k << "\t" << vec[k] << endl;
}

int main(int argc, char * argv[])
{
  if(argc <= 1)
    return 0;
  vi counts(256,0);
  ifstream fid;
  fid.open(argv[1], ios::in);
  while(fid.good())
    {
      string line;
      getline(fid, line);
      if(line[0]=='>')
	{
	  cout << "Reading contig " << line.substr(1,line.length()-1) << endl;
	  continue;
	}
      count_line(line, counts);
    }
  fid.close();
  
  print(counts);


}
