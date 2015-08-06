import sys

infile = sys.argv[1]
#Correct cases where only 1 alternate allele exists and genotype = 1/2 to genotype = 0/1
for line in open(infile):
    if line.startswith("#"):
        print  line.rstrip("\n")
    else:
        line = line.rstrip("\n").split("\t")
        #If number of alternate alleles is not equal to the maximum number in the GT field, warn 
        if len(line[4].split(",")) != max([int(x) for x in line[9].split(":")[0].split("/")]):
            sys.stderr.write("\t".join(line))
            if line[9].split(":")[0] == "1/2":
                line[9] = line[9].split(":")
                line[9][0] = "0/1"
                line[9] = ":".join(line[9])
                sys.stderr.write(" [1/2...corrected to 0/1]")
            sys.stderr.write("\n")
        print "\t".join(line)
        
            
