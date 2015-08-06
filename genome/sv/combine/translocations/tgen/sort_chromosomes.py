import sys

def ParseFields(line):
    var = {}
    line = line[:-1].lstrip(">").split("\t")
    for i,x in enumerate(line):
        var[x] = i
        
    return var


infile = sys.argv[1]
sorted_lines = 0
total = 0

with open(infile) as f:
    line = next(f)
    var = ParseFields(line)
    line = line[:-1].split("\t")
    line = line[:-3]
    line.extend(["chr1Sorted", "chr2Sorted", "pos1Sorted", "pos2Sorted"])
    print("\t".join(line))

    for line in f:
        line = line[:-1].split("\t")
        line = line[:-3]
        chr1,pos1 = line[var["chr1"]], line[var["pos1"]]
        chr2,pos2 = line[var["chr2"]], line[var["pos2"]]
        if chr1==chr2 or line[var["class"]]!="inter_chr":
            continue
        if int(chr1) < int(chr2):
            line.extend([chr1, chr2, pos1, pos2])
        else:
            sorted_lines += 1
            #TODO: Change 23,24 to X, Y etc.
            line.extend([chr2, chr1, pos2, pos1])   
        total += 1

        print("\t".join(line))
sys.stderr.write("%d / %d lines were sorted as chr1 > chr2 \n" % (sorted_lines, total))
