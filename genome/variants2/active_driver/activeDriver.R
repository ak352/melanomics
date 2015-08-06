
rm(list=ls())
#setwd("/work/projects/melanomics/analysis/genome/activeDriver/example")
setwd("/work/projects/melanomics/analysis/genome/activeDriver")
library(ActiveDriver)

##load data - pancancer
sequences = read_fasta("/work/projects/melanomics/data/activeDriver/data/pancancer/sequences_for_TCGA_pancancer.fa")
disorder = read_fasta("/work/projects/melanomics/data/activeDriver/data/pancancer/sequence_disorder_for_TCGA_pancancer.fa")
#mutations = read.table("/work/projects/melanomics/data/activeDriver/data/pancancer/all_mutations_for_TCGA_pancancer.tab")
active_sites = read.table("/work/projects/melanomics/data/activeDriver/data/pancancer/all_phosphosites_for_TCGA_pancancer.tab")


#NEW input files
#sequences = read_fasta("/work/projects/melanomics/data/activeDriver/data/example_new/refseq_protein_sequences.genes.txt")
#disorder = read_fasta("/work/projects/melanomics/data/activeDriver/data/example_new/refseq_protein_sequence_disorder.genes.txt")
#mutations = read.table("/work/projects/melanomics/data/activeDriver/data/example_new/mutations_pancan12.txt")
#active_sites = read.table("/work/projects/melanomics/data/activeDriver/data/example_new/PTM_sites.genes.txt", header=T, sep="\t")


##load example data 
#sequences = read_fasta("/work/projects/melanomics/data/activeDriver/data/example/all_proteins.fa")
#disorder = read_fasta("/work/projects/melanomics/data/activeDriver/disorder_all_proteins.fa")
#active_sites = read.table("/work/projects/melanomics/data/activeDriver/data/example/all_phosphosites.tab")

##change patients
##load our data
mutations = read.table("/work/projects/melanomics/analysis/genome/activeDriver/input/patient_8.input.activeDriver.txt", header=T, stringsAsFactors=F)

## tcga primary melanomas - only SNPs (not DNPs)
#mutations = read.table("/work/projects/melanomics/analysis/genome/activeDriver/input/tcga/broad.skcm.primary.SNP.ad.maf", header=T, stringsAsFactors=F)

## tcga metastatic melanomas - only SNPs (not DNPs)
#mutations = read.table("/work/projects/melanomics/analysis/genome/activeDriver/input/tcga/broad.skcm.met.SNP.ad.maf", header=T, stringsAsFactors=F)

##run ActiveDriver
results = ActiveDriver(sequences, disorder, mutations, active_sites, mc.cores=24)
#results2 = ActiveDriver(sequences, disorder, mutations, kinase_dom, mc.cores=12, simplified=T)
# return_records=T #to output more details

#write output
a = results$all_active_sites
#write.table(a, file="pancancer_active-sites.txt", sep="\t", quote=F)
write.table(a, file="patient8_active-sites.TEST.txt", sep="\t", quote=F)
#write.table(a, file="broad.skcm.primary.SNP_active-sites.txt", sep="\t", quote=F)
#write.table(a, file="broad.skcm.met.SNP_active-sites.txt", sep="\t", quote=F)

b = results$all_region_based_pval
#write.table(b, file="pancancer_region_based_pval.txt", sep="\t", quote=F)
write.table(b, file="patient8_region_based_pval.TEST.txt", sep="\t", quote=F, row.names=F)
#write.table(b, file="broad.skcm.primary.SNP_region_based_pval.txt", sep="\t", quote=F, row.names=F)
#write.table(b, file="broad.skcm.met.SNP_region_based_pval.txt", sep="\t", quote=F, row.names=F)

c = results$all_gene_based_fdr
#write.table(c, file="pancancer_region_based_fdr.txt", sep="\t", quote=F)
write.table(c, file="patient8_region_based_fdr.TEST.txt", sep="\t", quote=F, row.names=F)
#write.table(c, file="broad.skcm.primary.SNP_region_based_fdr.txt", sep="\t", quote=F, row.names=F)
#write.table(c, file="broad.skcm.met.SNP_region_based_fdr.txt", sep="\t", quote=F, row.names=F)

d = results$all_active_regions
#write.table(d, file="pancancer_active_regions.txt", sep="\t", quote=F)
write.table(d, file="patient8_active_regions.TEST.txt", sep="\t", quote=F, row.names=F)
#write.table(d, file="broad.skcm.primary.SNP_active_regions.txt", sep="\t", quote=F, row.names=F)
#write.table(d, file="broad.skcm.met.SNP_active_regions.txt", sep="\t", quote=F, row.names=F)

e = results$merged_report
#write.table(e, file="pancancer_merged_report.txt", sep="\t", quote=F)
write.table(e, file="patient8_merged_report.TEST.txt", sep="\t", quote=F, row.names=F)
#write.table(e, file="broad.skcm.primary.SNP_merged_report.txt", sep="\t", quote=F, row.names=F)
#write.table(e, file="broad.skcm.met.SNP_merged_report.txt", sep="\t", quote=F, row.names=F)

#f = results$all_active_mutations
#write.table(f, file="pancancer_active_mutations.txt", sep="\t", quote=F)
#write.table(f, file="patient6_active_mutations.txt", sep="\t", quote=F,row.names=F)

#g = results$gene_records
#write.table(g, file="pancancer_gene_records.txt", sep="\t", quote=F)
#write.table(g, file="patient6_gene_records.txt", sep="\t", quote=F, row.names=F)
