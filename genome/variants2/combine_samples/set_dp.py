import sys

for line in open(sys.argv[1]):
    #sys.stderr.write(line)
    if line.startswith("#"):
        print line.rstrip("\n")
        if line.startswith("#CHROM"):
            offset = len(line.rstrip("\n").split("\t")[9:])
            sys.stderr.write("offset = " + str(offset) + "\n")
    else:
        assert not line.startswith("#")
        line = line.rstrip("\n").split("\t")
        form = line[8].split(":")
        dp_index = None
        for x in range(len(form)):
            if form[x]=="DP":
                dp_index = x
        if not dp_index:
            sys.stderr.write("WARN: No DP in FORMAT field: " + "\t".join(line) + "\n")
            form.append("DP")
            dp_index = len(form)-1 
        

        samples = line[9:9+offset]
        k = 9
        for x in range(len(samples)):
            values = samples[x].split(":")
            for m in range(len(values), len(form)):
                values.append(".")
            values[dp_index] = line[k+offset]
            samples[x] = ":".join(values)
            k += 1
        

        newline = []
        newline.extend(line[0:8])
        newline.append(":".join(form))
        newline.extend(samples)
        print "\t".join(newline)

