#!/bin/bash --login
#Load pre-requisites
module load CMake/2.8.12-goolf-1.4.10
module load BioPerl/1.6.1-goolf-1.4.10-Perl-5.16.3
module load BWA/0.6.2-goolf-1.4.10
module load BLAT/3.5-goolf-1.4.10
module load Primer3/2.3.0-goolf-1.4.10
module load R/3.0.1-goolf-1.4.10-bare
export PATH=/work/projects/melanomics/tools/samtools/samtools-0.1.19/:$PATH
# export PATH=/work/projects/melanomics/tools/samtools/samtools_blcr/:$PATH
export PATH=/work/projects/melanomics/tools/blast/blast-2.2.24/bin:$PATH
mybamtoolsfolder=/work/projects/melanomics/tools/meerkat/Meerkat/src/mybamtools
export LD_LIBRARY_PATH=$mybamtoolsfolder/lib:$LD_LIBRARY_PATH

bam=$1

load_hg19()
{
    bwaindex=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa.bwt
    fai=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa.fai
    fasta_path=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/
    rmsk=/work/projects/melanomics/data/repeats/hg19_rmsk
}

load_hg18()
{
    bwaindex=/work/projects/melanomics/data/old_refGenome/hg18/hg18.fa.bwt
    fai=/work/projects/melanomics/data/old_refGenome/hg18/hg18.fa.fai
    fasta_path=/work/projects/melanomics/data/old_refGenome/hg18
    rmsk=/work/projects/melanomics/data/repeats/hg18_rmsk
}



MEERKAT_DIR=/work/projects/melanomics/tools/meerkat/Meerkat
# MEERKAT_DIR=/work/projects/melanomics/tools/meerkat/blcr/Meerkat
# OUT_DIR=$SCRATCH/meerkat
OUT_DIR=/work/projects/melanomics/analysis/genome/patient_2_NS/sv/meerkat

#1. Pre-process
preprocess()
{
    time perl $MEERKAT_DIR/scripts/pre_process_akrishna.pl \
	-b $bam \
	-I $bwaindex \
	-A $fai \
	-k 1500 \
	-t 8 \
	-s 20 \
	-q 15 \
	# -o $OUT_DIR
}

#2. Replace tumour genome blacklist with the matched genome blacklist
replace()
{
    if [[ $bam == *PM.bam ]]
	then
	echo $bam is a tumour genome
	date
	echo Copying tumour genome blacklist to ${bam%.bam}_blacklist/${bam%.bam}.blacklist.gz... 
	mkdir ${bam%.bam}_blacklist
	rsync -avz --progress ${bam%.bam}.blacklist.gz ${bam%.bam}_blacklist/.
	echo Symlinking matched normal genome blacklist
	ln -vfs ${bam%PM.bam}NS.blacklist.gz ${bam%.bam}.blacklist.gz
	date
	echo Done.
	else
	echo $bam is a normal genome
    fi
    
}

#3. Meerkat
meerkat()
{
     time perl $MEERKAT_DIR/scripts/meerkat.pl \
	 -b $bam \
	 -F ${fasta_path} \
	 -R blacked \
	 -m 0 \
	 -t 8 \
	 -d 5 \
	 -s 20 \
	 -p 5 \
	 -o 3
     
}

#4. Mechanism
mechanism()
{
    time perl $MEERKAT_DIR/scripts/mechanism.pl \
	-b $bam \
	-R $rmsk

}


# load_hg18
echo OAR_JOBID = $OAR_JOBID
load_hg19
preprocess
replace
meerkat
mechanism
