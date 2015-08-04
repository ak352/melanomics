#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <queue>
#include <algorithm>

#define VERBOSE 0
#define INTERVAL 40000000

void report(int count, std::string line, std::queue<std::string> lines, std::ifstream &fid, bool &error);
std::string format(int num);
bool is_dna(std::string line); 

int main(int argc, char * argv[])
{
  char * filename = argv[1];
  std::ifstream fid;
  fid.open(filename, std::ios::in);

  std::string line;
  int count = 0;
  std::queue<std::string> lines;
  std::getline(fid, line);
  bool error = 0;
  while(fid.good())
    {
      lines.push(line);
      if(count>=4)
	lines.pop();

      std::string::iterator it;
      switch(count%4)
	{
	case 0:
	  if(line.empty())
	    report(count, line, lines, fid, error);
	  else if(line.at(0)!='@')
	    report(count, line, lines, fid, error);
	  break;
	case 1:
	  it=line.begin();
	  if(!(*it == 'A' || *it == 'C' || *it == 'T' || *it == 'G' || *it == 'N'))
	    report(count, line, lines, fid, error);
	  //if(is_dna(line))
	  //report(count, line, lines, fid);
	  break;
	case 2:
	  if(line.empty())
	    report(count, line, lines, fid, error);
	  else if(line.at(0)!='+')
	    report(count, line, lines, fid, error);
	  break;
	default:
	  break;
	}
      
      if(VERBOSE && count % INTERVAL == 0)
	{
	  std::cout << "Read number " << format(count/4) << std::endl;
	  std::cout << line << std::endl;
	}
      count++;
      if(error)
	return 0;
      //Put this at the end so that the next line is used only if fid is good
      std::getline(fid, line);
    }
  
  std::cout << "Validated " << count/4 << " reads\n";
}

bool is_dna(std::string line) 
{
  std::string::iterator it;
  std::sort(line.begin(), line.end());
  it = std::unique(line.begin(), line.end());
  line.resize(std::distance(line.begin(), it));
  for(it=line.begin(); it!=line.end(); it++)
    if(!(*it == 'A' || *it == 'C' || *it == 'T' || *it == 'G' || *it == 'N'))
      return 0;
  return 1;


}

std::string format(int num)
{
  
  std::stringstream ss;
  ss << num;
  std::string str1;
  ss >> str1;
  int m = 0;
  for(int k = str1.length(); k!=0;k--)
    {
      if(m%3==0 && m>0)
	{
	  str1.insert(k, ",");
	}
      m++;
    }
  return str1;

}

void report(int count, std::string line, std::queue<std::string> lines, std::ifstream &fid, bool &error)
{
  error = 1;
  std::cout << "Error: Line ";
  std::cout << count << std::endl;
  std::cout << line << std::endl;
  std::cout << "History: ";
  while(!lines.empty())
    {
      std::cout << lines.front() << std::endl;
      lines.pop();
    }
  for(int k = 0; k < 4;k++)
    {
      std::cout << "Next 4 lines: \n"; 
      std::string l;
      if(fid.good())
	{
	  std::getline(fid, l);
	  std::cout << l << std::endl;
	}
      else
	{
	  std::cout << "Error: fid not good" << std::endl;
	  break;
	}
    }
}
