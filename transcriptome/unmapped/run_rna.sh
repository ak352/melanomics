
rna()
{
    sample=$1
    input1=/work/projects/melanomics/analysis/transcriptome/$sample/tophat_out_trimmed_NCBI_DE_SNP/tophat_out_trimmed_NCBI_DE_SNP_$sample/unmapped.bam
    input2=/work/projects/melanomics/analysis/transcriptome/$sample/tophat_out_trimmed_NCBI_DE_SNP/tophat_SE_NCBI_DE_SNP_$sample/unmapped.bam
    OUTDIR=/work/projects/melanomics/analysis/transcriptome/unmapped/$sample/
    mkdir -pv $OUTDIR
    output=$OUTDIR/$sample.unmapped.paired.bam
    stderr=${output%bam}stderr
    stdout=${output%bam}stdout
    # ls -ltrh $input1 $input2
    # oarsub -l/nodes=1/core=2,walltime=72 -O $stdout -E $stderr -n ${sample}_unmap "date; time samtools view -hf1 $input1 | samtools view -hSf4 - | samtools view -bhSf8 - > $output; time samtools index $output; date"  
    output=$OUTDIR/$sample.unmapped.paired.sorted
    stderr=${output%bam}stderr
    stdout=${output%bam}stdout
    #oarsub -l/nodes=1/core=2,walltime=72 -O $stdout -E $stderr -n ${sample}_sort "date; time samtools sort -n $input1 $output; date" 
    #oarsub -l/nodes=1/core=2,walltime=72 -O $stdout -E $stderr -n ${sample}_unmap "./rna.sh $1"


    output=$OUTDIR/$sample.unmapped.singleton.bam
    stderr=${output%bam}stderr
    stdout=${output%bam}stdout
    # ln -fs $input2 $output
    #oarsub -l/nodes=1/core=2,walltime=72 -O $stdout -E $stderr -n ${sample}_unmap "date; time samtools view -hF1 $input2 | samtools view -bhSf4 - > $output; time samtools index $output; date"

    input1=$OUTDIR/$sample.unmapped.paired.sorted.bam.only_pairs.bam
    input2=$OUTDIR/$sample.unmapped.singleton.bam
    output=$OUTDIR/$sample.unmapped.bam
    oarsub -l/nodes=1/core=2,walltime=72 -O $stdout -E $stderr -n ${sample}_unmap "date; time samtools merge $output $input1 $input2; date "
}

# for k in 6 #2 4_NS 4_PM 
# do
#      rna patient_$k
# done
# rna NHEM
rna pool 
