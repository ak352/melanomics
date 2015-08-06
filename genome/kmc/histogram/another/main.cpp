#include <algorithm>
#include <iostream>

#include <fcntl.h>  // O_RDONLY
#include <unistd.h> // read
#include <cstring>  // memchr
#include <vector>
#include <sstream>
#include <string>

void handle_error(const char* msg)
{
  perror(msg);
  exit(255);
}

static uintmax_t wc(char const *fname, std::vector<int> &counts)
{
  static const auto BUFFER_SIZE = 16*1024;
  int fd = open(fname, O_RDONLY);
  if(fd == -1)
    handle_error("open");

  /* Advise the kernel of our access pattern.  */
  posix_fadvise(fd, 0, 0, 1);  // FDADVICE_SEQUENTIAL

  char buf[BUFFER_SIZE + 1];
  uintmax_t lines = 0;


  while(size_t bytes_read = read(fd, buf, BUFFER_SIZE))
    {
      if(bytes_read == (size_t)-1)
	handle_error("read failed");
      if (!bytes_read)
	break;

      char * begin = buf;
      for(char *p = buf; (p = (char*) memchr(p, '\n', (buf + bytes_read) - p)); ++p)
	{
	  std::istringstream ss(std::string(begin, p));
	  int n;
	  ss >> n;
	  counts[n]++;	   
	  ++lines;
	  begin = p+1;
	}
    }
    
  return lines;
}

int main(int argc, char * argv[])
{
  if(argc >1)
    {
      std::vector<int> counts(256,0);
      auto m_numLines = wc(argv[1], counts);
      std::cout << "m_numLines = " << m_numLines << "\n";
      for(int k = 0; k < counts.size(); k++)
	std::cout << k << "\t" << counts[k] << std::endl;

    }
}
