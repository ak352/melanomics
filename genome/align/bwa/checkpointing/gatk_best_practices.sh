#!/bin/bash --login

MYTMP=$SCRATCH/bwa/
mkdir $MYTMP
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
dbsnp=/work/projects/melanomics/data/broad2/bundle/dbsnp_138.b37.vcf


index()
{
    oarsub -lcore=2,walltime=12 "./run_index.sh $ref"
}    


stage_in()
{
    echo Staging to SCRATCH...
    sample=$1
    mkdir $SCRATCH/trim/
    rsync -ah --progress /work/projects/melanomics/analysis/genome/$sample/trim/* $SCRATCH/trim/.
    echo Done staging.
}


bwa_pe_se()
{

    sample=$1
    for k in /work/projects/melanomics/analysis/genome/$sample/trim/*trimmed_1
    do
	input=${k##*/}
	input=$SCRATCH/trim/$input
	lane=`echo $k | grep -oP '[0-9].ft.R1_1.fastq.noadapter.quality_trimmed_1' | sed 's/\.ft\.R1_1\.fastq\.noadapter\.quality_trimmed_1//g'`
	read1=$input
	read2=${input%1}2
	readse=${input%1}SE
	sample_name=$sample
	dob=${k##*/}
	dob=${dob%%_*} 

	read_group="\"@RG\tID:$dob_$lane\tSM:$sample_name\tPL:Illumina\tLB:NA\tPU:NA\""
	output_pe=$MYTMP/$sample_name.$dob.lane$lane.pe.sam
	output_se=$MYTMP/$sample_name.$dob.lane$lane.se.sam
	cores_pe=4
	cores_se=4
	
	#echo ./run_bwa.sh $read_group $ref $read1 $read2 $output_pe $cores_pe
	#echo ./run_bwa_se.sh $read_group $ref $readse $output_se $cores_se

	pe_stdout=$MYTMP/$sample_name.$dob.lane$lane.pe.stdout
	pe_stderr=$MYTMP/$sample_name.$dob.lane$lane.pe.stderr
	se_stdout=$MYTMP/$sample_name.$dob.lane$lane.se.stdout
        se_stderr=$MYTMP/$sample_name.$dob.lane$lane.se.stderr
	#echo  -O $pe_stdout -E $pe_stderr
	#echo -O $se_stdout -E $se_stderr
	oarsub -tbigsmp -lcore=$cores_pe,walltime=120 -n ${output_pe##*/} -O $pe_stdout -E $pe_stderr "./run_bwa.sh $read_group $ref $read1 $read2 $output_pe $cores_pe"
	oarsub -tbigsmp -lcore=$cores_se,walltime=120 -n ${output_se##*/} -O $se_stdout -E $se_stderr "./run_bwa_se.sh $read_group $ref $readse $output_se $cores_se"
    done
}

merge_pe_se()
{
    sample=$1
    for k in $MYTMP/$sample*.pe.sam
    do
        input_pe=$k
        input_se=${k%pe.sam}se.sam
        output=${k%pe.sam}bam
	stout=${output%bam}stdout
	sterr=${output%bam}stderr
	#echo "./merge_pe_se.sh $input_pe $input_se $output"   
        oarsub -lcore=2,walltime=24 -n $sample.$lane -O $stout -E $sterr "./merge_pe_se.sh $input_pe $input_se $output"
    done
}


sort_and_mark_duplicates()
{
    sample=$1
    for k in $MYTMP/$sample.[0-9]*.lane[0-9].bam
    do
	input=$k
	output=${k%bam}sorted.markdup.bam
	stout=${output%bam}stdout
	sterr=${output%bam}stderr
	context=${output%bam}context
	context=${context##*/}
	#echo ./run_sort_markduplicates.sh $input $output
	oarsub -n $sample -O $stout -E $sterr -S "./run_sort_markduplicates.sh $input $output $context"
    done
}

realign()
{
    sample=$1
    for k in $MYTMP/$sample.[0-9]*.lane[0-9].sorted.markdup.bam
    do
	input=$k
	output=${k%bam}realn.bam
	intervals=${k%bam}realn.intervals
	stout=${output%bam}stdout
        sterr=${output%bam}stderr
        context=${output%bam}context
        context=${context##*/}
	#oarsub -lcore=2,walltime=24 -tbigmem -n $sample "./run_realignment.sh $input $ref $output $intervals"
	oarsub -n $sample -O $stout -E $sterr -S "./run_realignment.sh $input $ref $output $intervals $context"
    done
}


recalibrate()
{
    sample=$1
    for k in $MYTMP/$sample.[0-9]*.lane[0-9].sorted.markdup.realn.bam
    do
	input=$k
	output=${k%bam}recal.bam
	grp=${output%.bam}.grp
	stout=${output%bam}stdout
        sterr=${output%bam}stderr
        context=${output%bam}context
        context=${context##*/}
	#oarsub -lcore=2,walltime=24 -n $sample "./run_recalibrate.sh $input $ref $dbsnp $output $grp"
	oarsub -n $sample -O $stout -E $sterr -S "./run_recalibrate.sh $input $ref $dbsnp $output $grp $context" 
    done
    
}

merge()
{
    #Merge all lanes
    sample=$1
    cmd="./run_merge_lanes.sh "
    input_bams=`ls -1 $MYTMP/$sample.[0-9]*.lane[0-9].sorted.markdup.realn.recal.bam| sed 's/.*/& /g'| tr -d '\n'`
    out=$MYTMP/$sample
    sterr=$out.stderr
    stout=$out.stdout
    context=${out##*/}.context
    cmd="$cmd $input_bams "
    cmd="$cmd $MYTMP/$sample.bam"
    cmd="$cmd $MYTMP/$sample.reheader.bam"
    cmd="$cmd $context"


    #echo $cmd
    oarsub -n $sample -O $stout -E $sterr -S "$cmd"
    #echo "oarsub -lcore=2,walltime=24 -n $sample $cmd"

}

stage_out()
{
    MYTMP=/scratch/users/sreinsbach/bwa
    sample=$1
    echo Staging $sample BAM files and index out to WORK...
    out=/work/projects/melanomics/analysis/genome/$sample/bam
    mkdir $out
    echo Copying $MYTMP/$sample.bam and $MYTMP/$sample.bai to $out/.
    rsync -ah --progress $MYTMP/$sample.bam $out/.
    rsync -ah --progress $MYTMP/$sample.bai $out/.
    echo Done staging.
}



unifiedgenotyper()
{
    sample=$1
    input=$MYTMP/$sample.sorted.markdup.realn.recal.bam
    output=$MYTMP/$sample.sorted.markdup.realn.recal.ugt.vcf
    cores=8
    oarsub -lcore=$cores,walltime=24 -n $sample "./run_ugt.sh $input $output $dbsnp $ref $cores"
}

variant_recalibrate()
{
    sample=$1
    input=$MYTMP/$sample.sorted.markdup.realn.recal.ugt.vcf
    output=$MYTMP/$sample.sorted.markdup.realn.recal.ugt.vqsr.vcf
    cores=8
    oarsub -lcore=$cores,walltime=24 -n $sample -t bigsmp "./run_variant_recalibrate.sh $input $output $dbsnp $ref $cores"
}

flagstat()
{
    directory=$MYTMP
    ls -1 $directory/*.bam > $directory/bam_files
    out=$MYTMP/bam_stats
    sterr=$out.stderr
    stout=$out.stdout
    context=${out##*/}.context
}


## Pipeline
#index

#stage_in NHEM

#bwa_pe_se patient_2_NS
#bwa_pe_se patient_2_PM
#for n in 6 7 8 #4 5 #6 7 8
#do
#    for m in NS PM
#    do
#	bwa_pe_se patient_${n}_${m}
#    done
#done
#bwa_pe_se NHEM

#for n in 8 #2 #5 6 7 #8 #4
#do
#    for m in NS PM
#    do
#	merge_pe_se patient_${n}_${m}     
#    done
#done
#merge_pe_se NHEM


#for n in 2 4 #8 #4 2 5 6 7
#do
#    for m in NS #PM
#    do
#        sort_and_mark_duplicates patient_${n}_${m}
#    done
#done
#sort_and_mark_duplicates NHEM

#for n in 4 #5 #4 8 #2 6 7 #8 # 4 5
#do
#    for m in NS #PM
#    do#
#	realign patient_${n}_${m} 
#    done
#done
#realign NHEM

#for n in 4 #2 5 6 7 8
#do
#    for m in NS #PM
#    do
#	recalibrate patient_${n}_${m}
#    done
#done
#recalibrate NHEM

# for n in 4 #2 5 6 7 8
# do
#     for m in NS #PM
#     do
#         merge patient_${n}_${m}
#     done
# done
#merge NHEM


# for n in 2 4 5 6 7 8
# do
#     for m in NS PM
#     do
# 	stage_out patient_${n}_${m}
#     done
# done
# stage_out NHEM

for n in 2 4 5 6 7 8
do
    for m in NS PM
    do
	flagstat patient_${n}_${m}
    done
done
flagstat NHEM





#For k in patient_2 patient_4_NS patient_4_PM patient_6 NHEM pool
#do
#    unifiedgenotyper $k
#done


#for k in patient_2 patient_4_NS patient_4_PM patient_6 NHEM pool
#do
#    variant_recalibrate $k
#done
