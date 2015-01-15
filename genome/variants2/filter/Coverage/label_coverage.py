import sys
import pysam
#Creates a dictionary of fields pointing to column numbers, makes the code more readable                                                                                                                                             
def ParseFields(line):
    fields = {}
    var = line.rstrip("\n").lstrip("#").lstrip(">").split("\t")
    for x in range(0, len(var)):
        fields[var[x]] = x
    return fields

#Strips any leading ">" or "#" and lagging "\n", a very common operation for master files                                                                                                                                            
def Strip(line):
    var = line.rstrip("\n").lstrip("#").lstrip(">").split("\t")
    return var

#Given a variant line (already split by tab) from a VCF file, extract all the coverages in a list
def get_coverages(line):
    line = line.split("\t")
    format = line[8].split(":")
    genotypes = [genotype.split(":") for genotype in line[9:]]
    #print "genotypes = ", genotypes
    fields = {}
    for i,val in enumerate(format):
        fields[val] = i
    coverages = [genotype[fields["DP"]] for genotype in genotypes]
    return coverages
    

infile=sys.argv[1]
vcf=sys.argv[2]
tbx = pysam.Tabixfile(vcf)

for line in open(infile):
    if line.startswith(">"):
        var = ParseFields(line)
        oldline = Strip(line)
        newline = Strip(line)
        for x in oldline[8:]:
            newline.append("coverage_%s" % x)
        line = "\t".join(newline)
    else:
        line = Strip(line)
        chrom = line[var["chromosome"]]
        begin,end = [int(k) for k in line[var["begin"]], line[var["end"]]]
        if line[var["varType"]]=="ins":
            begin -= 1
        #for k in list(tbx.fetch(chrom, begin, end)):
        #    print k
        matches = list(tbx.fetch(chrom, begin, end))
        assert matches, ("No match in VCF for line: ", line)

        
        try:
            average = [int(x) for x in get_coverages(matches[0])]
        except:
            print "ERROR: "
            print get_coverages(matches[0])
            for match in matches:
                print match
            print

        for match in matches[1:]:
            #print "match = ", match
            coverages = [int(x) for x in get_coverages(match)]
            average = [x+y for x,y in zip(average, coverages)]
            #print "coverages = ", get_coverages(match)
        average = [x/len(matches) for x in average]
        line.extend([str(x) for x in average])
        line = "\t".join(line)
    print line
    #print


