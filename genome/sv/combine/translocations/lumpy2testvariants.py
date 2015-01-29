import sys
from pylab import *

def lumpy2test(sample):
    infile="/work/projects/melanomics/analysis/genome/lumpy_genome/trim/%s.tumor_v_normal.pesr.bedpe" % sample
    annotations = [("INTERCHROM", "TRA")]
    logfile="/work/projects/melanomics/analysis/genome/lumpy_genome/trim/%s.testvariants.log" % sample
    log = open(logfile, "w")

    count = {}
    somatic = {}
    for anno in annotations:
        out="/work/projects/melanomics/analysis/genome/lumpy_genome/trim/%s.%s.testvariants" % (sample, anno[1])
        outfile=open(out, "w")
        outfile.write("chrom1\tchrom2\tpos1\tpos2\n")

        count[anno] = 0
        somatic[anno] = 0
        for line in open(infile):
            line = line[:-1].split("\t")
            svtype = line[10]
            if svtype == "TYPE:%s" % anno[0]:
                ids = line[11]
                samples = [int(x.split(",")[0].lstrip("IDS:"))  for x in ids.split(";")]
                loci = line[13]
                if 2 in samples and 1 not in samples:
                    # print "SOMATIC:", svtype, ids, loci
                    loci = [x.split(":") for x in loci.split(";")]
                    loci[0]  = loci[0][1:]
                    outfile.write("\t".join([loci[0][0], loci[1][0], loci[0][1], loci[1][1]]) + "\n")
                    somatic[anno] += 1
                count[anno] += 1
        sys.stderr.write("Output written to %s\n" % out)
    log.write("sample\tSV type\tsomatic\ttotal\n")
    for anno in annotations:
        log.write("%s\t%s\t%d\t%d\n" % (sample, anno[0], somatic[anno], count[anno]))

def plotter(sample, svtypes):
    logfile="/work/projects/melanomics/analysis/genome/lumpy_genome/trim/%s.testvariants.log" % sample
    with open(logfile) as f:
        next(f)
        for line in f:
            line = line[:-1].split("\t")
            sid = line[0]
            svtype = line[1]
            if svtype not in svtypes:
                svtypes[svtype] = {}
                svtypes[svtype]["somatic"] = []
                svtypes[svtype]["all"] = [] 
            somatic = int(line[2])
            total = int(line[3])
            svtypes[svtype]["somatic"].append(somatic)
            svtypes[svtype]["all"].append(total)
    return svtypes

def plotter_all(svtypes):
    figure(figsize=(22,20))
    types = ["DELETION", "DUPLICATION", "INVERSION", "INTERCHROM"]
    for i,svtype in enumerate(types):
        subplot(2,2,i+1)
        bar(arange(len(svtypes[svtype]["all"])), asarray(svtypes[svtype]["all"]) - asarray(svtypes[svtype]["somatic"]), label="non-somatic", color="y")
        bar(arange(len(svtypes[svtype]["all"])), asarray(svtypes[svtype]["somatic"]), bottom=asarray(svtypes[svtype]["all"]) - asarray(svtypes[svtype]["somatic"]), label="somatic", color="g")
        title(svtype)
        ylabel("Number of structural variants")
        #print svtype, somatic, total
        
        xticks(arange(len(svtypes[svtype]["all"]))+0.5, [str("patient_%d" % p) for p in [2,4,5,6,7,8]])
    legend()
    outfile="/work/projects/melanomics/analysis/genome/lumpy_genome/trim/graph/somatic.pdf"
    savefig(outfile, bbox_inches="tight")
    sys.stderr.write("Plot saved as %s\n" % outfile)
    #show()

if __name__ == "__main__":
    snums=[2,4,5,6,7,8]
    svtypes = {}
    for snum in snums:
        sample="patient_%d" % snum
        lumpy2test(sample)
        #svtypes = plotter(sample, svtypes)
    #plotter_all(svtypes)



