import sys
sys.path.append("/work/projects/igepilot/tools/pyvcf//dependencies/ordereddict-1.1/install/lib/python2.6/site-packages/")
sys.path.append("/work/projects/igepilot/tools/pyvcf//PyVCF-0.6.0/")
import vcf
import collections


vcf_reader = vcf.Reader(open('../res_tests/contig.2', 'r'))
print vcf_reader.metadata
#print vcf_reader.formats
Format = collections.namedtuple('Format', ['id', 'num', 'type', 'desc'])
#CallData  = collections.namedtuple('calldata', fields)

vcf_reader.formats['VQ']= Format('VQ', 1, 'Float', 'Variant quality')
#print vcf_reader.formats

for record in vcf_reader:
    record.FORMAT = record.FORMAT + ":VQ" 
    for sample in record.samples:
        print sample["GT"]
        call = record.genotype(sample.sample)
        print call.data.GT

        #sample["VQ"] = record.QUAL
    print record.FORMAT, record.samples
    
