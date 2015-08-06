import sys
from pylab import *
from optparse import OptionParser

def get_all_chrom():
    chroms = ["chr"+str(k) for k in range(23)]
    chroms.extend(["chrX", "chrY", "chrMT"])
    return chroms

def plotter(chrom, intervals, cnvs, i, chromosomes):
    if len(chromosomes) > 1:
        subplot(6,4,i)
    print cnvs.shape
    print intervals.shape
    cnv_ratio = cnvs[:,1]/cnvs[:,0]
    
    indices = (cnv_ratio > 1.3) | (cnv_ratio < 0.7)
    #bar(intervals[indices], cnv_ratio[indices])
    plot(intervals, cnv_ratio, 'r-')
    #plot(intervals[indices], cnv_ratio[indices], 'r-')
    #plot(intervals, cnvs[:,0], 'r-')
    #plot(intervals, cnvs[:,1], 'b-')
    ylim([0,2])
    title(chrom)
    return 

if __name__ == "__main__":
    #infile = "/work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_2.cnv.list.NS.PM.tested"
    infile = "/work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_4.cnv.list.NS.PM.tested"

    parser = OptionParser()
    parser.add_option("-i", "--input", dest="input", help="CNV test-variants format file to display", default=infile)
    parser.add_option("-c", "--chrom", dest="chrom", action="append", help="chromosomes to display")
    options, args = parser.parse_args()

    if not options.chrom:
        options.chrom = get_all_chrom()

    sys.stderr.write("Regions that did not have a CNV call in either NS or PM were labeled as ploidy=1 \n")
    with open(infile) as f:
        line = next(f)
        line = line[:-1].split("\t")
        chrom,begin,end,cnv1,cnv2 = line
        #print chrom,begin,end,cnv1,cnv2
        prev_chrom = chrom

        begin = int(begin)
        end = int(end)
        cnv1 = float(cnv1)
        cnv2 = float(cnv2)

        intervals = array([begin,end]).T
        cnvs = array([cnv1, cnv2]).T
        cnvs = vstack((cnvs,array([cnv1, cnv2])))

        i = 1

        for line in f:
            line = line[:-1].split("\t")
            chrom,begin,end,cnv1,cnv2 = line
            begin = int(begin)
            end= int(end)
            cnv1 = float(cnv1)
            cnv2 = float(cnv2)

            if chrom == prev_chrom:
                #print intervals.shape
                intervals = hstack((intervals, array([begin]), array([end])))
                cnvs = vstack((cnvs,array([cnv1, cnv2]), array([cnv1, cnv2])))
                #print chrom,begin,end,cnv1,cnv2
            else:
                #print intervals, cnvs
                #print intervals.shape, cnvs.shape
                if prev_chrom in options.chrom:
                    plotter(prev_chrom, intervals, cnvs, i, options.chrom)
                    i += 1
                intervals = array([begin,end]).T
                cnvs = array([cnv1, cnv2]).T
                cnvs = vstack((cnvs,array([cnv1, cnv2])))


            prev_chrom = chrom


    show()    
