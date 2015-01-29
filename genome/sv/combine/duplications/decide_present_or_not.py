import sys

infile = sys.argv[1]
add = sys.argv[2]

keys = set()
presence = {}


for line in open(infile):
    line = line.rstrip("\n").split("\t")
    loci = tuple(line[0:3])
    if loci not in presence:
        presence[loci] = []
    presence[loci].append(line[3])
    keys.add(loci)

for key in keys:
    outline = list(key)
    outline.append(";".join(presence[key]))
    summa = 0
    if add=="True":
        for x in presence[key]:
            summa += int(x)
    
        outline.append(str(summa))
    print "\t".join(outline)


                    
