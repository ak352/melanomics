import fileinput

repl = {}
for line in open("replacement"):
    line = line[:-1].split("\t")
    repl[line[0]] = line[1]

for line in fileinput.input():
    line = line[:-1].split()
    for i,x in enumerate(line):
        if x in repl:
            line[i] = repl[x]
    print "\t".join(line)

