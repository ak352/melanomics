from pylab import *
import sys


def loadstats(infile):
    covs = []
    bins = []
    for line in open(infile):
        bin,cov = line[:-1].split("\t")
        bins.append(bin)
        covs.append(cov)
    return bins, covs
               

if __name__ =="__main__":
    normal = sys.argv[1]
    tumor = sys.argv[2]
    input_prefix = sys.argv[3]
    max_x = None
    if len(sys.argv) > 4:
        max_x = float(sys.argv[4])
        print max_x

    labels = ["concordant_normal", "discordant_normal", "concordant_tumor", "discordant_tumor"]
    colors = ["r", "b", "r", "b"]
    linestyles = ["-", "-", "--", "--"]

    xs = []
    ys = []
    for label in labels:
        x,y = loadstats("%s.NearestIndelDistance.%s.hist" % (input_prefix, label))
        xs.append(x)
        ys.append(y)

    data = [[x, y, s] for x,y,s in zip(xs,ys, labels)]
    figure()
    for i,point in enumerate(data):
        plot(point[0], point[1], label=point[2], linewidth=3.0, color = colors[i], linestyle = linestyles[i])
        if max_x:
            xlim([0,max_x])

    title("%s, %s" % (normal, tumor))
    legend()
    output = input_prefix
    savefig(output+".NearestIndelDistance.pdf")
    savefig(output+".NearestIndelDistance.svg")
    savefig(output+".NearestIndelDistance.eps")

