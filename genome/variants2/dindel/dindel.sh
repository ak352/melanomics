#!/bin/bash --login
# module load dindel
source dindel_path
module load SAMtools
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
dbsnp=/work/projects/melanomics/data/broad2/bundle/dbsnp_138.b37.vcf
tmpdir=$SCRATCH/dindel_tmp
mkdir -pv $tmpdir

sample=$1
diploid=$2
IN_DIR=/work/projects/melanomics/analysis/genome/$sample/bam/
OUT_DIR=/work/projects/melanomics/analysis/genome/$sample/variants/dindel/
WINDOW_DIR=$OUT_DIR/realign_windows/
bam=${IN_DIR}/$sample.bam
output_prefix=$OUT_DIR/${bam##*/}
output_prefix=${output_prefix%.bam}
window_filenames=$output_prefix.num_files

echo sample = $sample
echo input directory = $IN_DIR
echo output directory = $OUT_DIR
echo bamfile = $bam

mkdir $OUT_DIR
mkdir -pv $WINDOW_DIR
#The script performs stage 1, stage 2 and stage 3 for every file
stage1()
{
    date
    echo Stage 1 begins...
    output=${bam##*/}
    output=$OUT_DIR/${output%.bam}.dindel_output
    echo Writing outout to $output
    dindel --analysis getCIGARindels \
	--ref $ref \
	--outputFile $output \
	--bamFile $bam
    date
    echo Stage 1 done.

}

stage2()
{
    date
    echo Stage 2 begins...
    input=${bam##*/}
    input=$OUT_DIR/${input%.bam}.dindel_output.variants.txt
    output=$WINDOW_DIR/${bam##*/}
    output=${output%.bam}.realign_windows

    makeWindows.py --inputVarFile $input \
        --windowFilePrefix $output \
    	--numWindowsPerFile 1000
    ls -1 $output.* | grep -P "$output.[0-9]+.txt"| grep -oP "[0-9]+" > $OUT_DIR/input_stage3
    
    date
    echo Stage 2 done.
}


run_stage3()
{
    num=$1
    varFile=$WINDOW_DIR/$sample.realign_windows.$num.txt
    libFile=${output_prefix}.dindel_output.libraries.txt
    echo Running stage 3 for window file $num
    outputFile=$WINDOW_DIR/$sample.dindel_stage2_output_windows.$num
    if [[ $diploid -eq "1" ]]
	then
	ploidy="--doDiploid"
	else
	ploidy="--doPooled"
    fi
    dindel --analysis indels $ploidy \
        --bamFile $bam \
        --ref $ref \
        --varFile $varFile \
        --libFile $libFile \
        --outputFile $outputFile
}

stage3()
{    
    export WINDOW_DIR
    export output_prefix
    export sample
    export ref
    export bam
    export diploid
    export -f run_stage3
    #Separate task for each file
    #Use parallel here to get varFile
    date
    echo Stage 3 begins...
    cat $OUT_DIR/input_stage3 | parallel --tmpdir $tmpdir --progress run_stage3
    date
    echo Stage 3 done.
}

stage4()
{
    #For each window file
    echo Copying glf output to stage2_outputfiles
    ls -1 $WINDOW_DIR/$sample.dindel_stage2_output_windows.*.glf.txt > $output_prefix.dindel_stage3_outputfiles.txt
    echo Done
    date
    echo Stage 4 begins...
    if [[ $diploid -eq "1" ]]
	then
	echo "Using diploid model..."
	mergeOutputDiploid.py --inputFiles $output_prefix.dindel_stage3_outputfiles.txt \
            --outputFile $output_prefix.dindel.vcf \
            -r  $ref \
	    -f 0
	else
	echo "Using pooled (non-diploid) model..."
	mergeOutputPooled.py --inputFiles $output_prefix.dindel_stage3_outputfiles.txt \
	    --outputFile $output_prefix.dindel.vcf \
	    -r  $ref \
	    --numSamples 4 \
	    --numBamFiles 1 \
	    -f 0
    fi
    echo Output written to $output_prefix.dindel.vcf
    date
    echo Stage 4 done.

}

stage1
stage2
stage3
stage4