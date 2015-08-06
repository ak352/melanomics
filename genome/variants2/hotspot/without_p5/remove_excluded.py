import sys

infile = sys.argv[1]

with open(infile) as f:
    print next(f)[:-1]
    line = next(f)[:-1]
    lines = []
    
    while True:
        #print "line at 0 = ", line
        while line!="":
            lines.append(line)
            line = next(f)[:-1]
            #print "line in while loop  ", line
        #print "line = ", line
        if lines[1]!="EXCLUDED":
            print "\n".join(lines)

        line = next(f)[:-1]
        lines = []

