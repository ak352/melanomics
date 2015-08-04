## melanomics

### Scripts (in this git)
 * *akrishna_bashrc* - contains the .bashrc and .bash_profile for user akrishna
 * *bam* - contains scripts for creating BAM files for regions inside genes
 * *genome* - contains the scripts for the genome sequence workflow
 * *transcriptome* - contains the scripts for the transcriptome sequence workflow

#### Key subfolders
1. [CNV annotation] (genome/abscnseq/dgv)
2. [Hotnet2](genome/variants2/hotnet2/matrix)
3. [Hotspot analysis](genome/variants2/hotspot/)
4. [SNV density and hom-het ratio for Circos/POMO] (genome/variants2/density/)

### Not on this git

#### Data
The external databases such as human genome reference GrCh37, gene annotations, cancer mutations (COSMIC), 1000 Genome Project etc. used for various analyses by the **Scripts** are in the data folder. On gaia, this data folder is at	```/work/projects/melanomics/data/```.

#### Analysis

All the output data of the analyses performed by the **Scripts** are in the analysis folder, which has almost the same structure as the scripts folder. On gaia, this analysis folder is at ```/work/projects/melanomics/analysis/```.


#### Tools

All the commonly used tools (bwa, tophat, samtools, bcftools, vcftools, bedtools, GATK, annovar, cgatools etc.) are stored in the tools folder. On gaia, this tools folder is at ```/work/projects/melanomics/tools/```.

