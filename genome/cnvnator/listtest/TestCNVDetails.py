bgzip = "/work/projects/isbsequencing/tools/tabix-0.2.6pm/bgzip"
tabix = "/work/projects/isbsequencing/tools/tabix-0.2.6pm/tabix"
import os
import sys
sys.path.append("/work/projects/isbsequencing/tools/pysam/pysam-0.6//install/lib/python2.6/site-packages")
import pysam

segments = sys.argv[1]
skip=0
temp_folder = ".temp"

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
sys.stderr.write("!!!!start!!!!\n")
sample = sys.argv[2]

header_printed = False
assembly_file = {}
os.system("rm -rf "+temp_folder+"; mkdir "+temp_folder) 

# Creating tab-indexed file
sample = sample.rstrip("\n")
tabix_file = temp_folder+"/" + sample.split("/")[-1]+".gz"
#Bgzip compress
sys.stderr.write("!!!bgzipping to "+tabix_file+"!!!\n")
os.system(bgzip + " -c  " + sample +" > "+ tabix_file)
#Tabix index
sys.stderr.write("!!!Tabixing!!!\n")
os.system(tabix + " -f -S" + str(skip) + " -s1 -b2 -e3 "+ tabix_file)
sys.stderr.write("!!!Tabix done!!!\n")

# Annotating segments
sample = sample.rstrip("\n")
tabix_file=temp_folder+ "/" + sample.split("/")[-1]+".gz"
tab = pysam.Tabixfile(tabix_file)
reader = open(segments)
for line in reader:
    if line.startswith(">"):
        print line.strip() + "\t"+sample
    else:
        line = line.strip().split()
        try:
            results = tab.fetch(line[0], int(line[1]), int(line[2])-1)
            result_list = list(results)
                
        except ValueError:
            result_list = []
            """Can add error handling for loci out of range, start > end"""

        if result_list:
            ploidy = result_list[0].split("\t")[3]
        else:
            ploidy = "NA"

        print "\t".join(line) + "\t" +  ploidy
        assert len(result_list)<2 
    

reader.close()


