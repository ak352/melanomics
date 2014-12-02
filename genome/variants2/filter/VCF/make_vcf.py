from datetime import datetime, date, time
import os
import sys
sys.path.append("/mnt/projects/isbsequencing/tools/pysam/pysam-0.6/install/lib/python2.6/site-packages/")
import pysam

#Creates a dictionary of fields pointing to column numbers, makes the code more readable                                                                                  
def ParseFields(line):
    fields = {}
    var = line.rstrip("\n").lstrip("#").lstrip(">").split("\t")
    for x in range(0, len(var)):
        fields[var[x]] = x
    return fields

#Strips any leading ">" or "#" and lagging "\n", a very common operation for master files                                                                                 
def StripLeadLag(line):
    var = line.rstrip("\n").lstrip("#").lstrip(">").split("\t")
    return var





hg19 = pysam.Fastafile("/mnt/projects/isbsequencing/resources/refGenomes/hg19.fa")
file = open("../DistanceHomopolymer/output/nearest_hp_distance")
out = open("output.vcf", "w+")


#Enter header lines
out.write("##fileformat=VCFv4.0\n")
out.write("##fileDate=" + str(date.today()).translate(None, '-') + "\n")
out.write("##source=Abhimanyu Krishna\n")
out.write("##reference=SHSY5Y\n")
out.write("##phasing=partial\n")
out.write("##INFO=<ID=ZC,Number=1,Type=String,Description=\"Zygosity called by Complete Genomics\">\n")
out.write("##INFO=<ID=ZI,Number=1,Type=String,Description=\"Zygosity called by Illumina\">\n")
##INFO=<ID=DB,Number=0,Type=Flag,Description="dbSNP membership, build 129">
##INFO=<ID=H2,Number=0,Type=Flag,Description="HapMap2 membership">
out.write("##FILTER=<ID=cgrd30,Description=\"CG read depth above 30\">\n")
out.write("##FILTER=<ID=ilrd30,Description=\"IL read depth above 30\">\n")
out.write("##FILTER=<ID=cgvs30,Description=\"CG variant score above 30\">\n")
out.write("##FILTER=<ID=ilvs30,Description=\"IL variant score above 30\">\n")
out.write("##FILTER=<ID=id5,Description=\"Distance to indel <  5\">\n")
out.write("##FILTER=<ID=hp6,Description=\"Inside a homopolymer region of length > 6 bp\">\n")

##FILTER=<ID=s50,Description="Less than 50% of samples have data">
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=GQ,Number=1,Type=Integer,Description="Genotype Quality">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Read Depth">
##FORMAT=<ID=HQ,Number=2,Type=Integer,Description="Haplotype Quality">

out.write("#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\tGS00533\tSS6002862\n")

variants = {}
for line in file:
    #Number of substitutions ignored
    sub = 0

    var = StripLeadLag(line)
    if line.startswith(">"):
        fields = ParseFields(line)
    else:
        if var[fields["varType"]]!="sub":

            location  =(var[fields["chromosome"]], var[fields["begin"]])
            if var[fields["varType"]]!="ins" and var[fields["varType"]]!="del":
                pos = str(int(location[1])+1)
                location = (var[fields["chromosome"]], pos)

            if location not in variants:
                variants[location]=[]
            #Each location = (chr, begin) contains a list of variants associated with it
            variants[location].append(line)
        else:
            sub = sub+1

print "Number of substitutions ignored = ", sub


out_locations = []
for location in variants:
    
    out_var = []

    for line in variants[location]:

        var = StripLeadLag(line)


        chrom = location[0]
        position = location[1]
        #reference = var[fields["reference"]]
        
#        varType = var[fields["varType"]]

        #Convert from 0-based to 1-based, not required for insertions

#            if varType!="ins":
#                position = str(int(position)+1)
#            out.write(position + "\t")

        
    #If the variants are insertions fetch the reference allele
#    if reference == "":
        #pysam uses 0-based coordinates
#        reference = hg19.fetch(chrom, int(position)-1, int(position)).upper()
    reference = hg19.fetch(chrom, int(position)-1, int(position)).upper()

    xRef = []
    for line in variants[location]:
        var = StripLeadLag(line)
        xRef.append(var[fields["xRef"]])
    if "".join(xRef)=="":
        xRef = "."
    
    #Add the variant allele sequences
    alleleSeqs = []
    for line in variants[location]:
        var = StripLeadLag(line)
        if var[fields["varType"]]=="ins" or var[fields["varType"]]=="del":
            alleleSeqs.append(reference + var[fields["alleleSeq"]])
            
        else:
            alleleSeqs.append(var[fields["alleleSeq"]])
    if "".join(alleleSeqs)=="":
        alleleSeqs = ["."]
    
    

#        if var[fields["xRef"]]=="":
#            out.write(".")
#        else:
#            out.write(var[fields["xRef"]] + ";")

        
            #For insertions add 1bp before the insertion
#            if var[fields["reference"]]=="":
#                print hg19.fetch(var[fields["chromosome"]], int(var[fields["begin"]]), int(var[fields["begin"]])+1)
#                print line
#                out.write(hg19.fetch(var[fields["chromosome"]], int(var[fields["begin"]]), int(var[fields["begin"]])+1).upper() + "\t")
#                #out.write(".\t")
#            else:
#                out.write(var[fields["reference"]] + "\t")
        

#            if var[fields["alleleSeq"]]=="":
#                out.write(".\t")
#            elif varType=="ins":
#                out.write(hg19.fetch(var[fields["chromosome"]], int(var[fields["begin"]]), int(var[fields["begin"]])+1).upper() + var[fields["alleleSeq"]] + "\t")
#            else:
#                out.write(var[fields["alleleSeq"]] + "\t")

    out_var.append(chrom)
    out_var.append(int(position))
    out_var.append(";".join(xRef))
    out_var.append(reference)
    out_var.append(",".join(alleleSeqs))
    out_locations.append(out_var)

out_locations.sort()

for location in out_locations:
    location[1]=str(location[1])
    out.write("\t".join(location) + "\n")




file.close()
out.close()
