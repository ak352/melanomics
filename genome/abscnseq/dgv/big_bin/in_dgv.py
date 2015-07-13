import fileinput
import sys

def ParseFields(line):
    fields = {}
    var = line.rstrip("\n").lstrip("#").lstrip(">").split("\t")
    for x in range(0, len(var)):
        fields[var[x]] = x
    return fields

f = fileinput.input()
line = next(f)
var = ParseFields(line)

print line[:-1] + "\tfound_in_dgv"
for line in f:
    line = line[:-1].split("\t")
    varid = line[var["variantaccession"]]
    if varid:
        summer = 0
        for x in varid.split(";"):
            x = x.split(":")
            try:
                summer += int(x[1])
            except:
                sys.stderr.write(varid + "\n")
                sys.stderr.write(x[0] + "\n")
                sys.exit()
            
        if summer > 50:
            found = "y"
        else:
            found = "n"
    else:
        found = "n"
    line.append(found)
    print "\t".join(line)
