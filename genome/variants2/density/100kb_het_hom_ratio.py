import sys

# infile = "/work/projects/isbsequencing/shsy5y/data/masterfile/master.GS00533.SS6002862.tested.illumina"
# info = "/work/projects/isbsequencing/resources/refGenomes/hg19.info"
# out = open("/work/projects/isbsequencing/shsy5y/analysis/variant_count/hom_percentage", "w+")
infile = sys.argv[1]
info = sys.argv[2]
out = open(sys.argv[3], "w+")

het = {}
homo = {}

total = {}
winsize = 100000
sys.stderr.write("[INFO] Window size = %s bp\n" % str(winsize))

chroms = []
for x in range(23):
    chroms.append(str(x))
chroms.append("X")
chroms.append("Y")
chroms.append("MT")
sys.stderr.write("[INFO] Contigs used: %s\n" % ", ".join(chroms))


for line in open(info):
    line = line.rstrip("\n").split("\t")
    chrom = line[0]
    bases = line[1]
    if chrom not in chroms:
        continue
    """Get the number of bases in each window"""
    for x in range(0, int(bases), winsize):
        het[(chrom, x)] = 0
        homo[(chrom, x)] = 0
        total[(chrom, x)] = min(winsize, int(bases)-x)

for line in open(infile):
    if not line.startswith("variantId") and not line.startswith(">"):
        line = line.rstrip("\n").split("\t")
        hom = line[8]=="11"
        chrom = line[1]
        loc = int(line[2])
        bin = winsize * int(loc/winsize)
        if hom:
            homo[(chrom, bin)] += 2
        else:
            het[(chrom, bin)] += 1
#print count                                                                                                    



pct = {}
for x in het:
    #Density per window                                                                                         
    try:
        pct[x] = float(homo[x])/(float(homo[x])+float(het[x]))
    except ZeroDivisionError:
        print "ZeroDivisionError at ", x, het[x], homo[x]
        pct[x] = 0
    out.write("\t".join([x[0], str(x[1]), str(total[x]+x[1]), str(pct[x])]))
    out.write("\n")

out.close()
