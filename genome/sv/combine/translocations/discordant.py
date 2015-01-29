import fileinput

f = fileinput.input()
print next(f)[:-1]+"\tconcordance"

for line in f:
    line = line[:-1].split("\t")
    is_concordant = True
    for k in range(9,len(line)-1):
        is_concordant &= (line[k]==line[k+1])
    if is_concordant:
        line.append("concordant")
    else:
        line.append("discordant")
    print "\t".join(line)
