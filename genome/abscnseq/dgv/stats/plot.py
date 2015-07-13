from pylab import *

samples = [2,4,6,7,8]
infiles = ["/work/projects/melanomics/analysis/genome/abscnseq/P%s.cnv.adj.called.wheader.dgv.per_gene.mean_ratios.log" % sample for sample in samples]

labels = ["patient_%d" % sample for sample in samples]

for i,infile in enumerate(infiles):
    n,bins = loadtxt(infile)
    #print n, bins
    plot(n, bins, lw=3, label=labels[i])

xlabel("Log of average ratio of normalised depths of tumor/normal")
ylabel("Number of genes")
legend()
savefig("/work/projects/melanomics/analysis/genome/abscnseq/stats/gene_copy.png")
savefig("/work/projects/melanomics/analysis/genome/abscnseq/stats/gene_copy.pdf")
savefig("/work/projects/melanomics/analysis/genome/abscnseq/stats/gene_copy.svg")


figure()

infiles = ["/work/projects/melanomics/analysis/genome/abscnseq/P%s.cnv.adj.called.wheader.dgv.per_gene.mean_ratios_novel.log" % sample for sample in samples]

for i,infile in enumerate(infiles):
    n,bins = loadtxt(infile)
    #print n, bins
    plot(n, bins, lw=3, label=labels[i])


xlabel("Log of average ratio of normalised depths of tumor/normal")
ylabel("Number of genes with novel CNVs")
legend()
savefig("/work/projects/melanomics/analysis/genome/abscnseq/stats/gene_copy_novel.png")
savefig("/work/projects/melanomics/analysis/genome/abscnseq/stats/gene_copy_novel.pdf")
savefig("/work/projects/melanomics/analysis/genome/abscnseq/stats/gene_copy_novel.svg")


show()    
