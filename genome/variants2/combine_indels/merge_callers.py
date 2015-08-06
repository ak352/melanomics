# Reports a consensus allele call from different variant callers only if - 
# more than 1 variant caller supports that variant
# Variants supported by only 1 variant caller are filtered out
import sys


passed = 0
filtered = 0

for line in open(sys.argv[1]):
    if line.startswith("##"):
        print line.rstrip("\n")
    elif line.startswith("#CHROM"):
        line = line.rstrip("\n").split("\t")
        line = line[0:9]
        line.append(sys.argv[2])
        print "\t".join(line)
    else:
        line = line.rstrip("\n").split("\t")
        attribs = line[8].split(":")
        num_callers_has_indel = 0

        max_alternate_alleles = 0
        for x in range(len(attribs)):
            if attribs[x]=="GT":
                #Since all positions are covered by some reads, all ./. are homozygous reference (0/0)
                for sample in line[9:]:
                    sample = sample.split(":")
                    #Increment number of callers that called this variant
                    if sample[x]!="./.":
                        num_callers_has_indel += 1
                        alternate_alleles = set(sample[x].split("/"))
                        if "0" in alternate_alleles:
                            alternate_alleles.remove("0")
                        #Choose the merged genotype to be the one with the maximum different types of alleles - a sensitive strategy
                        if len(alternate_alleles) > max_alternate_alleles:
                            max_alternate_alleles = len(alternate_alleles)
                            consensus = ":".join(sample)
                break


        newline = line[0:9]
        if num_callers_has_indel >= 2:
            newline[6]="PASS"
        else:
            newline[6]="FAIL"
        #Add the consensus zygosity, which is the zygosity with the maximum number of unique alleles
        newline.append(consensus)

        if num_callers_has_indel >= 2:
            passed+=1
            print "\t".join(newline)
        else:
            filtered+=1


sys.stderr.write("Total number of variants = "+ str(passed+filtered) + "\n")
sys.stderr.write("Variants passed = "+ str(passed) + "\n")
sys.stderr.write("Variants filtered = "+ str(filtered) + "\n")
