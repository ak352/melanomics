

infile = "/work/projects/isbsequencing/shsy5y/data/masterfile/master.GS00533.SS6002862.tested.illumina"
info = "/work/projects/isbsequencing/resources/refGenomes/hg19.info"
count = {}
for line in open(infile):
    if not line.startswith("variantId"):
        line = line.rstrip("\n").split("\t")
        hom = line[8]=="11" and line[9]=="11"
        chrom = line[1]
        if chrom not in count:
            count[chrom] = 0
        if hom:
            count[chrom] += 2
        else:
            count[chrom] += 1
print count

total = {}
for line in open(info):
    line = line.rstrip("\n").split("\t")
    chrom = line[0]
    bases = line[1]
    total[chrom] = int(bases)

density = {}
for x in count:
    #print count[x], total[x]
    density[x] = float(count[x])/float(total[x])
    print x, density[x]*1000000

    


            
        
