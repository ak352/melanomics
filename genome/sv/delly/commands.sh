#!/bin/bash --login
PATH=/work/projects/melanomics/tools/delly/delly/python/:$PATH
PATH=/work/projects/melanomics/tools/delly/delly/src/:$PATH
export PATH

module load Boost
exclude=/work/projects/melanomics/tools/delly/delly/human.hg19.excl.tsv 
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa

export OMP_NUM_THREADS=2

#Info message functions
status()
{
    d=`date`
    echo [$d] $1
}

out_status()
{
    d=`date`
    echo [$d] Output written to $1
    wc -l $1
}

# DELLY just needs one bam file for every sample and the reference genome to identify split-reads. 
# The output is in vcf format. The SV type can be DEL, DUP, INV or TRA for deletions, tandem duplications, inversions and translocations, respectively.
# Each bam file is assumed to be one sample. If you do have multiple bam files for a single sample please merge these bams using tools such as Picard and tag each library with a ReadGroup. To save runtime it is advisable to exclude telomere and centromere regions. For human, DELLY ships with such an exclude list.

bam1=$1
bam2=$2
OUTDIR=$3
sv=$4
mkdir -v $OUTDIR 

out_prefix=${bam2##*/}
out_prefix=${out_prefix%%.bam}
out_prefix=$OUTDIR/$out_prefix

# for sv in DEL DUP INV TRA
# do
# status "Performing delly for sv type: $sv ..."
# status "bam file: $bam1"
# status "bam file: $bam2"
# status "reference: $ref"
# status "exclude file: $exclude"
# status "SV type: $sv"
out=$out_prefix.$sv.vcf
#delly -t $sv -x $exclude -o $out -g $ref $bam1 $bam2
#out_status $out
    
    # filtered=${out%vcf}filt.vcf
    # status "Filtering $out ..."
    # somaticFilter.py -v $out -o $filtered -t $sv -s 500 -f
    # out_status $filtered
# done





# If you omit the reference sequence DELLY skips the split-read analysis. The vcf file follows the vcf specification and all output fields are explained in the vcf header.
# grep "^#" del.vcf

# DELLY ships with two small python scripts, one to filter somatic variants for tumor/normal comparisons and one to filter confident SV sites in population sequencing.
DELLY_DIR=/work/projects/melanomics/tools/delly/delly/
vcf=$out
out=${vcf%%.vcf}.somatic.vcf
status "Running delly somatic filter for sv type: $sv ..."
status "vcf file: $vcf"
status "output file: $out"

python $DELLY_DIR/python/somaticFilter.py -v $vcf -o $out -t $svtype -f
out_status $out
# python python/populationFilter.py -v del.vcf -o del.sites.vcf -g 30 -m 500 -n 5000000 -f

# These python scripts are primarily meant as an example of how you can filter and annotate the final DELLY vcf file further. They may require some fine-tuning depending on your application.
