import sys

col = int(sys.argv[2])-1

depths = [0]*1001

for line in open(sys.argv[1]):
    if line.startswith("#"):
        continue
    else:
        line = line[:-1].split("\t")
        format = line[8].split(":")
        fields = {}
        for x in range(len(format)):
            fields[format[x]] = x
            
        sample = line[col].split(":")
        dp = int(sample[fields["DP"]])
        if dp > 1000: # and dp < 200:
            print "\t".join(line)



        
