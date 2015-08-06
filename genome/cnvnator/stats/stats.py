from pylab import *

if __name__ == "__main__":
    samples = [2,4,5,6,7,8]
    cnv_files = ["/work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_%d_NS.cnv.1" \
                     % k for k in samples]
    cnv_files.extend(["/work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_%d_PM.cnv.1" \
                     % k for k in samples])

    """ Initialise counts and intervals """
    counts = {}
    intervals = {}
    for sample in samples:
        counts[sample] = [0,0]
        intervals[sample] = [[],[]]

    
    for i,infile in enumerate(cnv_files):
        for line in open(infile):
            line = line[:-1].split("\t")
            chrom, begin, end = line[0], int(line[1]), int(line[2])
            interval = end - begin
            #print line
            rd = float(line[3])

            # counts[i][0] contains line counts for NS and counts[i][1] contain those for PM samples
            counts[samples[i%len(samples)]][i/len(samples)] += 1
            # intervals[i][0] contains end - begin for each line for NS samples
            intervals[samples[i%len(samples)]][i/len(samples)].append(interval)

    

    types = ["NS", "PM"]
    for i,sample in enumerate(samples):
        for k in range(2):
            print "%s\t%d" % ("patient_%d_%s" % (sample, types[k]), counts[sample][k])

    

    # figure(figsize=(22,20))
    # colors = ["g", "r"]
    # labels = ["normal", "tumor"]
    # for i,sample in enumerate(samples):
    #     subplot(2,3,i+1)
    #     for k in range(2):
    #         [y, nbins] = histogram(intervals[sample][k], bins=100)
    #         nbins = nbins[1:]
    #         plot(log(nbins)/log(10), log(y)/log(10), lw=3, color=colors[k], label=labels[k])
    #         title("patient_%d" % sample)
    #         legend()
    #         xlabel("log(Number of CNV blocks)")
    #         ylabel("log(Size of CNV blocks)")
    # savefig("/work/projects/melanomics/analysis/genome/cnvnator/binSize100/stats/hist_size_cnv.pdf", bbox_inches="tight")
    #show()
   
        
