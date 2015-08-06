from pylab import *
from matplotlib.backends.backend_pdf import PdfPages

samples = [2,4,5,6,7,8]
cnv_files = ["/work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_%d.cnv.list.NS.PM.tested" % k for k in samples]


def get_cn(filename):
    bins_n = {}
    coverage_n = {}
    coverage_t = {}
    k = 0
    for line in open(filename):
        k += 1
        line = line[:-1].split("\t")
        loci = line[0:3]
        start,end = [int(x) for x in line[1:3]]
        
        if loci[0] not in bins_n:
            bins_n[loci[0]] = []
        if loci[0] not in coverage_n:
            coverage_n[loci[0]] = []
            coverage_t[loci[0]] = []
            
        #Append x and y
        #bins_n[loci[0]].append(start-1)
        #coverage_n[loci[0]].append(2)
        bins_n[loci[0]].append(start)
        bins_n[loci[0]].append(end-1)
        rds = [float(x) for x in line[3:5]]
        for i,rd in enumerate(rds):
            if rds[i] > 5:
                rds[i] = 5
        coverage_n[loci[0]].append(rd*2)
        coverage_n[loci[0]].append(rd*2)
        coverage_t[loci[0]].append(rd*2)
        coverage_t[loci[0]].append(rd*2)
        #bins_n[loci[0]].append(end)
        #coverage_n[loci[0]].append(2)
    return bins_n, coverage_n, coverage_t

def get_lengths():
    infile = "/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa.fai"
    lengths = {}
    for line in open(infile):
        line = line[:-1].split("\t")
        lengths["chr"+line[0]] = int(line[1])
    return lengths

if __name__ == "__main__":
    colors = ["r", "g", "b", "magenta", "cyan", "orange"]

    for j,cnv_file in enumerate(cnv_files):
        figure(figsize=(22,20))
        bins_n, coverage_n, coverage_t = get_cn(cnv_file)

        chroms = []
        for x in range(1,23):
            chroms.append("chr"+str(x))
        chroms.extend(["chrX", "chrY", "chrMT"])




        length = get_lengths()
        k = 1
        for chrom in chroms:
            subplot(5,5,k)
            # print len(bins_n[chrom]), len(coverage_n[chrom]), len(coverage_t[chrom])
            ratio = [float(x[1])/float(x[0]+0.000001) for x in zip(coverage_n[chrom], coverage_t[chrom])]
            # bins = []
            # nratio = []
            # for i,x in enumerate(ratio):
            #     if x < 0.5 or x > 1.5:
            #         bins.append(bins_n[chrom][i])
            #         nratio.append(x)
            # for m in range(0,len(bins),2):
            #     plot(bins[m:m+2], nratio[m:m+2], color=colors[j], label="patient_%d" % samples[j])
            # scatter(bins_n[chrom], ratio, color='r', s=2, label="tumor/normal ratio")   
            plot(bins_n[chrom], ratio, color='r', lw=3, label="tumor/normal ratio")   
            #scatter(bins_n[chrom], coverage_t[chrom], color='r', s=2, label="tumor")
            if k==25:
                legend()
            #plot(bins_n[chrom], coverage_n[chrom], color='b')
            #plot(bins_t[chrom], coverage_t[chrom], color='r')
            ylim([0,5])
            xlim([0,length[chrom]])
            title(chrom + "(patient_%d)" % samples[j])
            print chrom
            #print chrom, bins_n[chrom]
            #print chrom, coverage_n[chrom]
            k+=1
        outfile = "/work/projects/melanomics/analysis/genome/cnvnator/binSize100/graphs/patient_%d.cnv.pdf" % samples[j]
        savefig(outfile, \
                    bbox_inches = "tight")
        sys.stderr.write("Plots save at %s\n" % outfile)
    #plot(bins_n[chrom], coverage_n[chrom])
    #scatter(bins_n["chr1"], coverage_n["chr1"])
    #fig=gcf()
    #fig.set_size_inches(18.5,10.5)
    #fig.savefig('foo1.png',dpi=100)
    #show()






