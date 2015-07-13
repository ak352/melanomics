import sys
from pylab import *
import os

def get_stats(sample, svtype, counts, categories):
    infile="/work/projects/melanomics/analysis/genome/sv/merged/patient_%d.%s.list.lumpy.delly.tested" % (sample, svtype)
    if sample not in counts:
        counts[sample] = {}
    if svtype not in counts[sample]:
        counts[sample][svtype] = [0]*3
    
    # If testvariants file does not exist, return null counts
    if not os.path.isfile(infile):
        return counts, categories


    with open(infile) as f:
        next(f)
        for line in f:
            line = line[:-1].split("\t")
            lumpy, delly = [int(x) for x in line[3:5]]
            if lumpy and delly:
                counts[sample][svtype][0] += 1
            elif lumpy:
                counts[sample][svtype][1] +=1
            elif delly:
                counts[sample][svtype][2] +=1
    return counts, categories

def plotter(counts, svtypes, patients, categories):
    for svtype in svtypes:
        figure(figsize=(22,15))
        for i,patient in enumerate(patients):
            subplot(2,3,i+1)
            bar(arange(3), counts[patient][svtype])
            xticks(arange(3)+0.5, categories)
        savefig("/work/projects/melanomics/analysis/genome/sv/merged/graph/lumpy.delly.%s.pdf" % svtype)
        

if __name__ == "__main__":
    categories = ["concordant", "lumpy-only", "delly-only"]
    svtypes = ["DEL", "DUP", "INV"]
    counts = {}
    patients=[2,4,5,6,7,8]
    outfile = "/work/projects/melanomics/analysis/genome/sv/merged/lumpy.delly.log"
    out = open(outfile, "w")

    for patient in patients:
        for svtype in svtypes:
            counts, categories = get_stats(patient, svtype, counts, categories)
    

    out.write("patient\tSV type\tconcordant\tlumpy_only\tdelly_only\n")
    for svtype in svtypes:
        for patient in patients:
            a,b,c = counts[patient][svtype]
            out.write("%s\t%s\t%d\t%d\t%d\n" % (patient, svtype, a,b,c))
    sys.stderr.write("Log file written: %s\n" % outfile)

    plotter(counts, svtypes, patients, categories)


