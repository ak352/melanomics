# Sort the testvariants file such that chr1 < chr2
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


order =range(1,23)
order = [str(x) for x in order]
order.append("X")
order.append("Y")
order.append("M")
mapper = {}
for i,o in enumerate(order):
    mapper[o] = i

with open(infile) as f:
    line = next(f)
    var = ParseFields(line)
    line = line[:-1].split("\t")
    print("\t".join(line))

    for line in f:
        line = line[:-1].split("\t")
        chr1,pos1 = line[var["chrom1"]], line[var["pos1"]]
        chr2,pos2 = line[var["chrom2"]], line[var["pos2"]]
        if mapper[chr1] < mapper[chr2]:
            line = [chr1, chr2, pos1, pos2]
        else:
            sorted_lines += 1
            line = [chr2, chr1, pos2, pos1]
        total += 1

        print("\t".join(line))
sys.stderr.write("%d / %d lines were sorted as chr1 > chr2 \n" % (sorted_lines, total))
