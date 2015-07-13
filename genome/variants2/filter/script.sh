#!/bin/bash --login
#Variant filtering pipeline for small genomic variants in the Complete Genomics testvariants format
#Author: Abhimanyu Krishna
module load tabix

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

ROOT_DIR=$PWD
status "Root directory: $ROOT_DIR"
LISTVARIANTS=/work/projects/melanomics/analysis/genome/variants2/all.dna.coverage_annotated.testvariants
TABIX=/work/projects/melanomics/tools/tabix/tabix-0.2.6/tabix
# OUTPUT_DIR=/work/projects/melanomics/analysis/genome/variants2/filter
OUTPUT_DIR=/work/projects/melanomics/analysis/genome/variants2/somatic/filter

SIMPLE_REPEATS="http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/simpleRepeat.txt.gz"
RMSK="http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/rmsk.txt.gz"
MICROSAT="http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/microsat.txt.gz"
SCR="http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/chainSelf.txt.gz"
SEGDUP="http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/genomicSuperDups.txt.gz"

#1. Annotate with coverages
coverage_anno()
{
    sample=$1
    cd $ROOT_DIR/Coverage/
    input=../VariantScore/all.dna.coverage_annotated.testvariants
    vcfgz=/work/projects/melanomics/analysis/genome/variants2/intermediate/all.dna.coverage_annotated.vcf.gz
    output=$OUTPUT_DIR/cov.out
    python label_coverage.py $input $vcfgz > $output
}

#2. Annotate with variant scores
quality_anno()
{
    cd $ROOT_DIR/VariantScore/
    input=../VariantScore/all.dna.coverage_annotated.testvariants
    vcfgz=/work/projects/melanomics/analysis/genome/variants2/intermediate/all.dna.coverage_annotated.vcf.gz
    output=$OUTPUT_DIR/vs.out
    python label_gq.py $input > $output
}

#3. Nearest indel distance annotation
#cd $ROOT_DIR/NearAnIndel/ 
#rsync -avz --progress ../VariantScore/all.dna.coverage_annotated.testvariants ../VariantScore/vs.out
near_an_indel()
{
    sample=$1
    status "Getting indel distances for $sample..."
    python get_indel_distance.py $sample
    out_status "output/nearest_indel_distance"
    status "Copying to ../VariantScore/vs.out"
    cp output/nearest_indel_distance id.out
    status "Copied."
}

near_an_indel_all()
{
    input=../VariantScore/all.dna.coverage_annotated.testvariants
    output=$OUT_DIR/id.out
    cd $ROOT_DIR/NearAnIndel/ 
    cp $input id.out
    near_an_indel NHEM
    for k in 2 4 5 6 7 8
    do
	for m in NS PM
	do
	    sample=patient_${k}_${m}
	    near_an_indel $sample
	done
    done
    out_status id.out
    rsync -avz --progress id.out $output
}

#4. Homopolymer
homopolymer_once()
{
    status "Preparing homopolymers..."
    cd $ROOT_DIR/Homopolymer/
    python get_homopolymers.py
    #Sort and bgzip
    cat hg19_homopolymers | grep -v ^">"|sort -k1,1 -k2,2n -k3,3n |bgzip > hg19_homopolymers.gz
    $TABIX -0 -s1 -b2 -e3 hg19_homopolymers.gz
    status "Done."
}

homopolymer()
{
    status "Annotating homopolymers..."
    cd $ROOT_DIR/Homopolymer/
    input=../VariantScore/all.dna.coverage_annotated.testvariants
    output=$OUTPUT_DIR/hp.out
    python label_polymers.py $input > $output
    status "Done."
}

# #5. Simple repeats
simple_repeat_once()
{
    status "Preparing simple repeats..."
    cd $ROOT_DIR/SimpleRepeat
    wget $SIMPLE_REPEATS -O simple_repeat.gz
    gzip -d simple_repeat.gz
    cat simple_repeat | grep -v ^"#"| sed 's/chrM/chrMT/g'| sed 's/chr//g' | sort -k2,2 -k3,3n -k4,4n |bgzip > simple_repeat.gz
    $TABIX -s2 -b3 -e4 simple_repeat.gz
    status "Done."
}

simple_repeat()
{
    status "Annotating simple repeats..."
    cd $ROOT_DIR/SimpleRepeat
    input=../VariantScore/all.dna.coverage_annotated.testvariants
    output=$OUTPUT_DIR/sr.out
    python label_simple_repeat.py $input > $output
    status "Done."
}

# #6. Segmental duplications
segdup_once()
{
    status "Preparing segmental duplications..."
    cd $ROOT_DIR/SegmentalDuplication/
    wget $SEGDUP -O hg19_segdup.gz
    gzip -d hg19_segdup.gz
    cat hg19_segdup | grep -v ^"#"| sed 's/chrM/chrMT/g'| sed 's/chr//g' |sort -k2,2 -k3,3n -k4,4n |bgzip > hg19_segdup.gz
    $TABIX -s2 -b3 -e4 hg19_segdup.gz
    status "Done."
}

segdup()
{
    status "Anootation segmental duplications..."
    cd $ROOT_DIR/SegmentalDuplication/
    input=../VariantScore/all.dna.coverage_annotated.testvariants
    output=$OUTPUT_DIR/sd.out
    python label_segdup.py $input > $output
    status "Done."
}

# #7. Repeat Masker
rmsk_once()
{

    status "Preparing repeat masker..."
    cd $ROOT_DIR/RepeatMasker/
    wget $RMSK -O hg19_rm.gz
    gzip -d hg19_rm.gz
    cat hg19_rm | grep -v ^"#"| sed 's/chrM/chrMT/g'| sed 's/chr//g' |sort -k6,6 -k7,7n -k8,8n |bgzip > hg19_rm.gz 
    $TABIX -s6 -b7 -e8 hg19_rm.gz
    status "Done."
}
rmsk()
{
    status "Annotating repeat masker..."
    cd $ROOT_DIR/RepeatMasker/
    input=../VariantScore/all.dna.coverage_annotated.testvariants
    output=$OUTPUT_DIR/rm.out
    python label_rm.py $input > $output
    status "Done."
}

#8. Microsatellites
microsatellite_once()
{
    status "Preparing microsatellites..."
    cd $ROOT_DIR/Microsatellites/
    wget $MICROSAT -O hg19_microsatellites.gz
    gzip -d hg19_microsatellites.gz
    cat hg19_microsatellites | grep -v ^"#"| sed 's/chrM/chrMT/g'| sed 's/chr//g' |sort -k2,2 -k3,3n -k4,4n |bgzip > hg19_microsatellites.gz
    $TABIX -s2 -b3 -e4 hg19_microsatellites.gz
    status "Done."
}

microsatellite()
{
    status "Annotating microsatellites..."
    cd $ROOT_DIR/Microsatellites/
    input=../VariantScore/all.dna.coverage_annotated.testvariants
    output=$OUTPUT_DIR/ms.out
    python label_microsatellites.py $input > $output
    status "Done."
}

#9. Self-chained regions
scr_once()
{
    status "Preparing self-chained regions..."
    cd $ROOT_DIR/SelfChainedRegions/
    #wget $SCR -O self_chain.gz
    #gzip -d self_chain.gz
    cat self_chain | grep -v ^"#"| sed 's/chrM/chrMT/g'| sed 's/chr//g' |sort -k3,3 -k5,5n -k6,6n |bgzip > self_chain_target.gz
    cat self_chain | grep -v ^"#"| sed 's/chrM/chrMT/g'| sed 's/chr//g' |sort -k7,7 -k10,10n -k11,11n |bgzip > self_chain_query.gz
    $TABIX -s3 -b5 -e6 self_chain_target.gz
    $TABIX -s7 -b10 -e11 self_chain_query.gz
    status "Done."
}

scr()
{
    
    status "Annotating self-chained regions..."
    cd $ROOT_DIR/SelfChainedRegions/
    input=../VariantScore/all.dna.coverage_annotated.testvariants
    output=$OUTPUT_DIR/sr.out
    python label_self_chain.py $input > $output
    status "Done."
}

#10. Distance to homopolymer runs
distance_hp()
{
    status "Annotating distance to homopolymer runs..."
    input=../VariantScore/all.dna.coverage_annotated.testvariants
    output=$OUTPUT_DIR/dhp.out
    cd $ROOT_DIR/DistanceHomopolymer
    grep -v ^">" $ROOT_DIR/Homopolymer/hg19_homopolymers| awk -F"\t" '{print "hp\t"$1"\t"$2"\t"$3"\t"$4;}'  > hp_var_merged
    grep -v ^">" $input  >> hp_var_merged

    grep ^">" $input  > hp_var_merged.sorted
    sort -k2,2 -k3,3n -k4,4n hp_var_merged >> hp_var_merged.sorted
    python get_hp_distance.py $output
    status "Done."
}

paste_all()
{
    status "Pasting all annotations..."
    INPUT_DIR=/work/projects/melanomics/analysis/genome/variants2/filter
    status "Input directory: $INPUT_DIR"
    start_field=22
    status "Start column for annotation: $start_field"
    cmd="paste <( cut -f1-$((start_field-1)) $INPUT_DIR/cov.out)" 
    for k in cov vs id hp dhp ms rm sd sr
    do
	input=$INPUT_DIR/$k.out
	cmd="$cmd <( cut -f ${start_field}- $input) "
    done
    output=$OUTPUT_DIR/all.out
    cmd="$cmd > $output"
    echo $cmd
    eval $cmd
    out_status $output
}



# Preparing files for annotation
# homopolymer_one
# simple_repeat_once
# segdup_once
# rmsk_once
# microsatellite_once
# scr_once

option=$1
# $option
paste_all



# homopolymer
# simple_repeat
# segdup
# rmsk
# microsatellite
# scr
# distance_hp 
