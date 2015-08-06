
infile="/work/projects/melanomics/analysis/genome/variants2/filter/all.filter_annotation.out"
hapmap = "/work/projects/melanomics/analysis/genome/variants2/plink/hapmap/all.filter_annotation.out.hapmap"
outfile = open("/work/projects/melanomics/analysis/genome/variants2/plink/hapmap/all.filter_annotation.out.hapmap.variants", "w")
vids = set()
for line in open(hapmap):
    vids.add(line[:-1])
#print len(vids)



with open(infile) as f:
    outfile.write(next(f))
    for line in f:
        line = line[:-1].split("\t")
        if line[0] in vids:
            outfile.write("\t".join(line)+"\n")



