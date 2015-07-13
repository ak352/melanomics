#include <iostream>
#include <string>
#include <bam.h>
#include <vector>

using namespace std;
struct Interval
{
  uint32_t begin, end, min, max;
  vector<int> depth;
};

static int func(uint32_t tid, uint32_t pos, int depth, const bam_pileup1_t *pl, void *data)
{
  Interval * interval = (Interval *) data;
  // printf("pos=%d, start=%d, end=%d\n", pos, interval->begin, interval->end);
  if((uint32_t) pos < interval->min || (uint32_t) pos >= interval->max)
    return 0;

  while((int32_t) pos >= interval->end)
    {  
      interval->depth.push_back(0);
      interval->begin++;
      interval->end++;
      //if(interval->end >= max)
      //	return 0;
    }
  int coverage = 0;
  for(int k = 0; k < depth; k++)
    {
      //for each alignment at that position
      const bam_pileup1_t * curr = &pl[k];
      const bam1_t* b = curr->b;
      uint32_t qual = b->core.qual;
      //printf("%d, %d\n", b->core.pos+curr->qpos, coverage);
      //Filter for mapping quality > 0 (removes non-unique alignments) and base quality >= 13 (default mpileup) 
      if(qual <= 0 || bam1_qual(b)[curr->qpos] < 13)
	continue;
      
      //TODO: Remove low quality alignments
      coverage++;
    }
  
  interval->depth.push_back(coverage);
  interval->begin++;
  interval->end++;
  return 0;
}

// callback for bam_fetch()
static int fetch_func(const bam1_t *b, void *data)
{
  //printf("%s %d %d %d\n", b->data, b->core.tid, b->core.pos, b->core.l_qseq);
  bam_plbuf_push(b, (bam_plbuf_t * )data);
  return 0;
}

int get_depths(bamFile in, bam_index_t * idx, bam_plbuf_t * buf, uint32_t min, uint32_t max)
{
  
  Interval interval;
  interval.begin = 0;
  interval.end = 1;

  int binsize = 10000;
  for(int k = min; k < max; k = k+binsize)
    {
      interval.min = k;
      interval.max = k+binsize;
      buf = bam_plbuf_init(func, (void *) &interval);
      bam_fetch(in, idx, 0, interval.min, interval.max, buf, fetch_func);
      bam_plbuf_push(0, buf);
      for(int k = 0; k < interval.depth.size(); k++)
	printf("%d\t%d\n", k+interval.min, interval.depth[k]);
      interval.depth.clear();
    }
      
  //printf("depth = ");
  // for(int k = 0; k < interval.depth.size(); k++)
  //   printf("%d\t%d\n", k, interval.depth[k]);
  return 0;
}

int main()
{
  string bam_name = "/work/projects/melanomics/analysis/genome/patient_2_NS/bam/patient_2_NS.bam";
  printf("input = %s\n", bam_name.c_str());
  bam1_t *b=bam_init1();
  bam_header_t *header;
  bamFile in  = bam_open(bam_name.c_str(), "r");
  bam_index_t * idx = bam_index_load(bam_name.c_str());
  bam_plbuf_t * buf;
  if(!in || !b || !idx) return -1;
  header = bam_header_read(in);
  
  uint32_t min, max;
  min = 0;
  max = 249000000;
  get_depths(in, idx, buf, min, max);

  //for(int k = 0; k < interval.depth.size(); k++)
  // printf("%d\t%d\n", k, interval.depth[k]);  

  bam_header_destroy(header);
  bam_close(in);
  bam_destroy1(b);
  return 0;


}
