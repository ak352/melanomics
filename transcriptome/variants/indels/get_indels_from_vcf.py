import sys

infile=sys.argv[1]
count_indels = 0
for line in open(infile):
    if line.startswith("#"):
        print line.rstrip("\n")
    else:
        line = line.rstrip("\n").split("\t")
        ref = line[3]
        alt = line[4].split(",")
        
        has_indel = False
        for a in alt:
            if len(a)!=len(alt):
                has_indel = True
                
        if has_indel:
            count_indels += 1
            print "\t".join(line)

sys.stderr.write("SUMMARY: indel count = " + str(count_indels) + "\n")
