import sys
def ParseFields(line):
    var = {}
    line = line[:-1].lstrip(">").split("\t")
    for i,x in enumerate(line):
        var[x] = i
        
    return var


infile = sys.argv[1]
#infile = "/work/projects/melanomics/data/cosmic/CosmicCompleteExport.tsv"

num_confirmed = 0
num_confirmed_no_location = 0
num_confirmed_with_location = 0
total = 0
with open(infile) as f:
    line = next(f)
    var = ParseFields(line)
    print "chrom\tbegin\tend\t" + line[:-1]


    for line in f:
        line = line[:-1].split("\t")
        if line[var["Primary site"]] != "skin":
            continue

        status = line[var["Mutation somatic status"]]
        total += 1
        
        # Only process confirmed somatic variants
        if status == "Confirmed somatic variant":
            num_confirmed += 1
        else:
            continue
        

        try:
            chrom,positions = line[var["Mutation GRCh37 genome position"]].split(":")
        except ValueError:
            num_confirmed_no_location += 1
            continue
            #sys.stderr.write("\t".join(line))
            #sys.exit()
            
        begin,end = [int(x) for x in positions.split("-")]
        begin -= 1

        if chrom == "23":
            chrom = "X"
        if chrom == "24":
            chrom = "Y"
        if chrom == "25":
            chrom = "MT"

        num_confirmed_with_location += 1


        begin,end = [str(x) for x in [begin,end]]
        newline = [chrom, begin, end]
        newline.extend(line)
        print "\t".join(newline)


sys.stderr.write("SUMMARY for COSMIC mutations (skin):\n")
sys.stderr.write("Total number of mutations in COSMIC = %d\n" % total)
sys.stderr.write("Confirmed somatic variants in COSMIC = %d\n" % num_confirmed)
sys.stderr.write("Confirmed somatic variants in COSMIC which do not have a genomic location = %d\n" \
                     % num_confirmed_no_location)
sys.stderr.write("Confirmed somatic variants with genomic locations = %d\n" % num_confirmed_with_location)
