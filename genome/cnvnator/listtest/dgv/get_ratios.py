import sys


with open(sys.argv[1]) as f:
    print next(f)[:-1] + "\tPM_NS_ratio\tcnv_type"
    for line in f:
        line = line[:-1].split("\t")

        if float(line[3])==0:
            ratio = "-1"
        else:
            ratio = str(float(line[4])/float(line[3]))
        line.append(ratio)
        if ratio=="-1":
            line.append("zero_NS")
        else:
            if float(ratio) > 1.5:
                line.append("gain")
            if float(ratio) < 0.5:
                line.append("loss")
            if float(ratio) <= 1.5 and float(ratio) >=0.5:
                line.append("no change")

        print "\t".join(line)
