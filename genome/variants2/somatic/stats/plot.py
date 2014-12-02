from pylab import *
import sys

infiles = []
for k in [2,4,5,6,7,8]:
    infiles.append("/work/projects/melanomics/analysis/genome/variants2/somatic/stats/patient_%s.depth.hist" % str(k))

x = []
xrang=101
t = linspace(0,xrang,xrang)

for infile in infiles:
    y = []
    for line in open(infile):
        a,b = line[:-1].split()
        x.append(int(a))
        y.append(int(b))
    print len(t), len(y)
    plot(t, y[0:xrang], label=infile.split("/")[-1].split(".")[0])

xlabel("Read depth")
ylabel("Number of mutations")
legend()
#show()
savefig(sys.argv[1])
