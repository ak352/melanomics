import os
import sys
import bz2

def ParseFields(line):
    fields = {}
    var = line.rstrip("\n").lstrip("#").lstrip(">").split("\t")
    for x in range(0, len(var)):
        fields[var[x]] = x
    return fields

def StripLeadLag(line):
    var = line.rstrip("\n").lstrip("#").lstrip(">").split("\t")
    return var


#Read the folders and individual sample names
for k in [2,4,5,6,7,8]:
    infiles = ["/work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_%d_NS.cnv.1" % k,
               "/work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_%d_PM.cnv.1" % k]
    outfile = "/work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_%d.cnv.list" % k
    out = open(outfile, "w")
    segment_boundaries = {}
    header_printed = False

    for infile in infiles:
        for line in open(infile):
            var = StripLeadLag(line)
            if var[0] not in segment_boundaries:
                    segment_boundaries[var[0]] = set()
            segment_boundaries[var[0]].add(var[1])
            segment_boundaries[var[0]].add(var[2])


    for chrom in sorted(segment_boundaries):
        sorted_set = sorted(list(segment_boundaries[chrom]), key=int)
        for x in range(len(sorted_set)-1):
            out.write("\t".join([chrom, sorted_set[x], sorted_set[x+1]])+"\n")
    sys.stderr.write("Output written to %s\n" % outfile)

