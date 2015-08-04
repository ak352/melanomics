### Workflow for SNVs/indels (somatic and germline)
=======================================================


* *active_driver* - to analyse phosphroylated-SNVs
* *annotation* - gene annotation and other annotations using ANNOVAR
* *combine_indels* - to combine indels (VCF) from different callers
* *combine_mutect_strelka* - to combine VCF output from somatic SNV callers
* *combine_samples* - to combine VCF files from different samples
* *combine_variants* - to combine SNVs and indels
* *consistency* - checking for mutations present in normal that are lost in tumor
* *coverage_annotation* - to annotate VCF files with coverage
* *density* - compute heatmaps for SNV density and het/hom ratio for use in Circos/POMO plots
* *dindel* - Indel caller
* *dna_repair* - 
* *filter* - workflow for filtering variants based on coverage, quality scores, repeat regions etc.
* *germline* - an older classification of variants as germline [still used] and somatic [deprecated]
* *gsea* - computes exonic SNV density per gene
* *hotnet2* - to find significantly mutated subnetworks in a protein-protein interaction network 
* *hotspot* - to cluster variants in a VCF file for hotspot analysis
* *longest_transcript* - to get the longest transcript for each gene (to be tested)
* *magi* 
* *mutsig* - prepare input MAF file from VCF for MutSigCV tool
* *oncocis*
* *oncotator*
* *plink* - PLINK IBD analysis to check relationship between samples
* *risk_genes* - to check for mutations/mutated genes common across patients
* *somatic*
* *testvariants* - convert VCF file to Complete Genomics testvariants format, which we use for annotation and comparison
    
