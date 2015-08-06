from pylab import *
from matplotlib.backends.backend_pdf import PdfPages

normal="/work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_2_NS.cnv"
tumor="/work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_2_PM.cnv"

def get_cn(filename):
    bins_n = {}
    coverage_n = {}
    k = 0
    for line in open(filename):
        k += 1
        line = line[:-1].split("\t")
        if k <= 3:
            continue
        if len(line)<2:
            break
        loci = line[1].split(":")
        start,end = [int(m) for m in loci[1].split("-")]
        
        if loci[0] not in bins_n:
            bins_n[loci[0]] = []
        if loci[0] not in coverage_n:
            coverage_n[loci[0]] = []


        #Append x and y
        #bins_n[loci[0]].append(start-1)
        #coverage_n[loci[0]].append(2)
        bins_n[loci[0]].append(start)
        bins_n[loci[0]].append(end-1)
        rd = float(line[3])
        if rd > 5:
            rd = 5
        coverage_n[loci[0]].append(rd*2)
        coverage_n[loci[0]].append(rd*2)
        #bins_n[loci[0]].append(end)
        #coverage_n[loci[0]].append(2)
    return bins_n, coverage_n

def get_lengths():
    infile = "/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa.fai"
    lengths = {}
    for line in open(infile):
        line = line[:-1].split("\t")
        lengths["chr"+line[0]] = int(line[1])
    return lengths

bins_n, coverage_n = get_cn(normal)
bins_t, coverage_t = get_cn(tumor)

chroms = []
for x in range(1,23):
    chroms.append("chr"+str(x))
chroms.extend(["chrX", "chrY", "chrMT"])




length = get_lengths()
k = 1
for chrom in chroms:
    subplot(5,5,k)
    scatter(bins_n[chrom], coverage_n[chrom], color='b', s=2, label="normal")
    scatter(bins_t[chrom], coverage_t[chrom], color='r', s=2, label="tumor")
    if k==25:
        legend()
    #plot(bins_n[chrom], coverage_n[chrom], color='b')
    #plot(bins_t[chrom], coverage_t[chrom], color='r')
    ylim([0,10])
    xlim([0,length[chrom]])
    title(chrom)
    print chrom
    #print chrom, bins_n[chrom]
    #print chrom, coverage_n[chrom]
    k+=1

#plot(bins_n[chrom], coverage_n[chrom])
#scatter(bins_n["chr1"], coverage_n["chr1"])
#fig=gcf()
#fig.set_size_inches(18.5,10.5)
#fig.savefig('foo1.png',dpi=100)
show()






