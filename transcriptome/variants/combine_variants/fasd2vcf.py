import sys
import pysam

infile = open(sys.argv[1])
sample = sys.argv[2]
reference = pysam.Fastafile(sys.argv[3])
header = open("header")


for line in header:
    print line.strip()
print "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t"+sample

for line in infile:
    if line.startswith("Chromosome"):
        #print line.strip()
        continue
    
    line = line.rstrip("\n").split("\t")
    genotype = line[3]
    if genotype != "AA":
        chrom = line[0]
        pos = line[1]
        score = str(int(round(float(line[2]))))
        ref = line[4]
        alt = line[5]
        
        if len(ref)!=1 or len(alt)!=1:
            if ref[0]!=alt[0]:
                prefix = reference.fetch(chrom, int(pos)-2, int(pos)-1)
                ref = prefix + ref
                alt = prefix + alt
                pos = str(int(pos)-1)
                #print "INFO: " + prefix


        gt = None
        if genotype == "AB":
            gt = "0/1"
        if genotype == "BB":
            gt = "1/1"
        depth = line[6]
        if not gt:
            print line
            sys.exit()
        newline = [chrom, pos, ".", ref, alt, score, "PASS", ".", "GT:GQ:DP", ":".join([gt, score, depth])]
        
        print "\t".join(newline)
        #print "\t".join(line)
