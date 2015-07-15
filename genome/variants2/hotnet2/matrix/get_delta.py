import json
import numpy as np
import sys

# Input is output 'delta selection' script - bin/findThreshold.py
infile = sys.argv[1]
outfile = sys.argv[2]

print("Input: %s" % infile)
print("Output: %s" % outfile)
out = open(outfile, 'w')

# x = json.load(open("/scratch/users/akrishna/hotnet2/iref/delta/delta"))
x = json.load(open(infile))


out.write("size\tmedian_delta\n")
for size in sorted(map(int, x["deltas"].keys())):
    median = np.median(x["deltas"][str(size)])
    print median
    out.write("%d\t%2.7f\n" % (size, median))

out.close()


