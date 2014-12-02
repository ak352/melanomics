from pylab import *
import sys


def loadstats(infile):
    covs = []
    bins = []
    for line in open(infile):
        bin,cov = line[:-1].split("\t")
        bins.append(bin)
        covs.append(cov)
    summa = sum([float(cov) for cov in covs])
    for i,cov in enumerate(covs):
        covs[i] = float(cov)/summa
    return bins, covs
               

if __name__ =="__main__":
    output = "/work/projects/melanomics/analysis/genome/variants2/filter/graphs/quality/snv_indel_sub"
    labels = ["SNV", "Indels and subs"]
    files = ["/work/projects/melanomics/analysis/genome/variants2/filter/quality/snv_quality.hist", \
                 "/work/projects/melanomics/analysis/genome/variants2/filter/quality/indelsub_quality.hist"]
    colors = ["r", "b"]
    linestyles = ["-", "-"]

    data = [loadstats(infile) for infile in files]
    figure()
    for i,point in enumerate(data):
        plot(point[0], point[1], label=labels[i], linewidth=3.0, color = colors[i], linestyle = linestyles[i])

    title("Distribution of genotype qualities (GQ)")
    legend()
    savefig(output+".quality.pdf")
    savefig(output+".quality.svg")
    savefig(output+".quality.eps")
    show()

