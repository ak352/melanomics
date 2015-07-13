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
	#echo ./run_sort_markduplicates.sh $input $output
	oarsub -lcore=8,walltime=48 -tbigmem -n $sample -O $stout -E $sterr "./run_sort_markduplicates.sh $input $output"
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
	oarsub -lcore=2,walltime=24 -tbigmem -n $sample "./run_realignment.sh $input $ref $output $intervals"
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
	oarsub -lcore=2,walltime=24 -n $sample "./run_recalibrate.sh $input $ref $dbsnp $output $grp"
    done
    
}

merge()
{
    sample=$1
    cmd=" ./run_merge_lanes.sh "
    for k in $MYTMP/$sample.[0-9]*.lane[0-9].sorted.markdup.realn.recal.bam
    do
	cmd="$cmd $k "
    done
    cmd="$cmd $MYTMP/bwa/$sample.bam;"
    #Reheader to allow multiple read groups in the header
    cmd="${cmd} ./run_reheader.sh "
    for k in $MYTMP/$sample.[0-9]*.lane[0-9].sorted.markdup.realn.recal.bam
    do
        cmd="$cmd $k "
    done
    cmd="$cmd $MYTMP/bwa/$sample.bam $MYTMP/bwa/$sample.reheader.bam" 

    #oarsub -lcore=2,walltime=24 -n $sample "$cmd"
    echo "oarsub -lcore=2,walltime=24 -n $sample $cmd"

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


#for n in 4 #2 5 6 7 8
#do
#    for m in NS #PM
#    do
#        sort_and_mark_duplicates patient_${n}_${m}
#    done
#done
#sort_and_mark_duplicates NHEM


#realign patient_2_PM
realign NHEM
#for k in patient_2 patient_4_NS patient_4_PM patient_6 NHEM pool
#do
#    realign $k
#done

#for k in patient_2 patient_4_NS patient_4_PM patient_6 NHEM pool
#do
#    recalibrate $k
#done

#for k in NHEM pool #patient_2 patient_4_NS patient_4_PM patient_6 # NHEM pool patient_6
#do
#    merge_pe_se $k
#done                                                                                                                                                                                                                                

#for k in pool NHEM #patient_2 patient_4_NS patient_4_PM patient_6 #pool NHEM
#do
#    merge $k
#done


#for k in patient_2 patient_4_NS patient_4_PM patient_6 NHEM pool
#do
#    unifiedgenotyper $k
#done


#for k in patient_2 patient_4_NS patient_4_PM patient_6 NHEM pool
#do
#    variant_recalibrate $k
#done
