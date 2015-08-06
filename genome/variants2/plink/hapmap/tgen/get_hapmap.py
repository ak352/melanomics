import sys


infile = sys.argv[1]
hapmap = sys.argv[2]

ids = set()

with open(hapmap) as h:
    line = next(h)[:-1]
    while line[:2]=="##":
        line = next(h)
    for line in h:
        line = line[:-1].split("\t")
        assert line[2][:2]=="rs"
        ids.add(line[2])

with open(infile) as f:
    line = next(f)[:-1]
    print line
    while line[:2]=="##":
        line = next(f)[:-1]
        print line
    for line in f:
        line = line[:-1].split("\t")
        if line[2] in ids:
            print "\t".join(line)
