
library(ActiveDriver)
#sequences = read_fasta("/work/projects/melanomics/data/activeDriver/data/example/all_proteins.fa")
#disorder = read_fasta("/work/projects/melanomics/data/activeDriver/disorder_all_proteins.fa")
mutations = read.table("/work/projects/melanomics/data/activeDriver/all_mutations_100.tab")
active_sites = read.table("/work/projects/melanomics/data/activeDriver/data/example/all_phosphosites.tab")

results1 = ActiveDriver(sequences, disorder, mutations, active_sites, mc.cores=8)

a = results1$all_active_sites
write.table(a, file="pat6_all_active-sites.txt", sep="\t", quote=F)

b = results1$all_region_based_pval
write.table(b, file="pat6_all_region_based_pval.txt", sep="\t", quote=F)

c = results1$all_gene_based_fdr
write.table(c, file="pat6_all_region_based_fdr.txt", sep="\t", quote=F)

