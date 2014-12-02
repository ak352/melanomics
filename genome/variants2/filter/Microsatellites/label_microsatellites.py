import sys

sys.path.append("/mnt/projects/isbsequencing/tools/pysam/pysam-0.6//install/lib/python2.6/site-packages")
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





hp = pysam.Tabixfile("hg19_microsatellites.gz")

#file = open("../RepeatMasker/rm.out")
file = open(sys.argv[1])
out = open("ms.out", "w+")


for line in file:
    var = StripLeadLag(line)
    if line.startswith(">"):
        fields = ParseFields(line)
        sys.stdout.write(line.rstrip("\n") + "\tmicrosatellites\n")
    else:
        chromosome = var[fields["chromosome"]]
        begin = int(var[fields["begin"]])
        end = int(var[fields["end"]])

        #As tabix does not work if begin=end for query                                                                                                                  
        if var[fields["varType"]]=="ins":
            end = end+1

        locations = hp.fetch(chromosome, begin, end)
        s = list(locations)
        
        if len(s) > 0:
            
            #print s[0]
            sys.stdout.write(line.rstrip("\n") + "\t" + ";".join(s[0].split("\t")) + "\n")
        else:
            sys.stdout.write(line.rstrip("\n") + "\t\n")

file.close()
hp.close()

