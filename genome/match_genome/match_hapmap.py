import sys

def ParseFields(line):
    var = {}
    line = line[:-1].lstrip(">").split("\t")
    for i,x in enumerate(line):
        var[x] = i
        
    return var

idset = set()
with open(sys.argv[2]) as g:
    next(g)
    for line in g:
        idset.add(line[:-1])
    


f = open(sys.argv[1])

header = next(f)
var = ParseFields(header)
print header[:-1]


matches = {}
normals =[m for m in sorted(var.keys()) if m[-2:]=="NS" and m[:2] == "pa" ]
tumors =[m for m in sorted(var.keys()) if m[-2:]=="PM" and m[:2] == "pa"]
print normals
print tumors
called = {}

for m in normals:
    matches[m] = [0]*6
    called[m] = [0]*6

#print matches
min_coverage = 10
max_coverage = 200

for j,line in enumerate(f):
    line = line[:-1].split("\t")
    if line[var["variantId"]] in idset:
        for normal in normals:
            for i,tumor in enumerate(tumors):
                ## Same genotype - strict!
                cov_n = int(line[var["coverage_"+normal]])
                cov_t = int(line[var["coverage_"+tumor]])
                if cov_n >= min_coverage and cov_n <= max_coverage \
                        and cov_t >= min_coverage and cov_t <= max_coverage:
                    if "1" in line[var[normal]] and "1" in line[var[tumor]]:
                        matches[normal][i] += 1
                    #if "1" in line[var[normal]] or "1" in line[var[tumor]]:
                    if "1" in line[var[normal]]:
                        if "N" not in line[var[normal]] and "N" not in line[var[tumor]]:
                            called[normal][i] += 1
    if j%1000000 == 0:
        sys.stderr.write("%d lines processed...\n" % j)
    #if j > 1000000:
    #    break

print "Min. coverage: %d" % min_coverage
print "Max. coverage: %d" % max_coverage
print "Matches:"
for normal in normals:
    print matches[normal]

print "Called:"
for normal in normals:
    print called[normal]

print "Match percentage:"
for normal in normals:
    pc = tuple([float(x)*100/float(y) for (x,y) in zip(matches[normal], called[normal])])
    print("%2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f" % (pc[0], pc[1], pc[2], pc[3], pc[4], pc[5]))
              

