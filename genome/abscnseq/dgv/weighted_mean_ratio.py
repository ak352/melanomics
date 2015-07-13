import sys
import matplotlib
matplotlib.use('Agg')
from pylab import *
import math

def has_dgv(string):
    strings = string.split(";")
    for s in strings:
        s = s.split(":")
        if s[0]=="y" and int(s[1])>50:
            return True
    return False



infile = sys.argv[1]
logfilename  = infile + ".log"
logfile = open(logfilename, "w")

# Logs the names of genes with no overlap with CNV regions
sys.stderr.write("Logfile: %s\n" % logfilename)
num_genes_no_annotation = 0

with open(infile) as f:
    line = next(f)[:-1]
    print line + "\t mean_NS_PM_ratio"

    mean_ratios = []
    mean_ratios_novel = []
    for line in f:
        gene = line[0]
        line = line[:-1].split("\t")
        dgv = line[2]

        if not line[1]:
            logfile.write("[WARNING] %s has an instance with no overlap with CNV regions (possible if it is a gene on an unmapped contig)\n")
            num_genes_no_annotation += 1
            continue

        ratios = line[1].split(";")

        summer = 0
        sum_proportion = 0
        for ratio in ratios:
            ratio = ratio.split(":")
            summer += math.exp(float(ratio[0]))*float(ratio[1])
            sum_proportion += float(ratio[1])
        mean_ratio = math.log(summer/sum_proportion)
        mean_ratios.append(mean_ratio)
        if not has_dgv(dgv):
            mean_ratios_novel.append(mean_ratio)
        line.append("%2.2f" % mean_ratio)
        print "\t".join(line)
    
    
    # Report number of instances of genes that were excluded because of no overlap with CNV regions
    sys.stderr.write("%d instances of genes with no overlap with CNV region. See logfile.\n" \
                         % num_genes_no_annotation)

    # Get histogram of NS_PM ratios for genes
    ioff()
    mean_ratios = array(mean_ratios)
    n,bins,patches = hist(mean_ratios, arange(-2,2,0.05))
    bins = (bins[1:] + bins[:-1])/2
    hist_file = infile+".mean_ratios.log"
    savetxt(hist_file, vstack([bins,n]))
    
    sys.stderr.write("Histogram of mean ratios written to %s\n" % hist_file)



    mean_ratios_novel = array(mean_ratios_novel)
    n,bins,patches = hist(mean_ratios_novel, arange(-2,2,0.05))
    bins = (bins[1:] + bins[:-1])/2
    hist_file = infile+".mean_ratios_novel.log"
    savetxt(hist_file, vstack([bins,n]))
    
    sys.stderr.write("Histogram of mean ratios for genes with novel CNVs written to %s\n" % hist_file)


        
        
