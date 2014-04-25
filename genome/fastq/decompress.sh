#!/bin/bash --login
module load bzip2
#SCRATCH=/scratch/users/sreinsbach/
TMP_DIR=$SCRATCH/fastq
mkdir $TMP_DIR

decompress()
{
    sample=$1
    echo Decompressing $sample
    folder=/work/projects/melanomics/analysis/genome/$sample/fastq
    for k in $folder/*.bz2
    do
	#echo $k
	#NFS stalling
	temp=${k%.bz2}
	temp=$TMP_DIR/${temp##*/}
	echo  Unzipping on /tmp/ as  $temp
	oarsub -lcore=2,walltime=120 -n $sample "echo  Decompressing on /tmp/ as  $temp; echo Decompressing $k ...; time bzip2 -ckd $k > $temp; echo Moving...; echo Done; echo Moving...; mv $temp $folder/.;"
	#mv $temp $folder/.
	#oarsub -lcore=2,walltime=120 -n $sample "echo Decompressing $k ...; time bzip2 -ckd $k > ${k%.bz2}; echo Done;"
    done
    echo Decompression done.
}

decompress_file()
{
    fid=$1
    sample=$2
    temp=${fid%.bz2}
    temp=$TMP_DIR/${temp##*/}
    folder=/work/projects/melanomics/analysis/genome/$sample/fastq
    oarsub -lcore=2,walltime=120 "echo  Decompressing on /$SCRATCH/ as  $temp; echo Decompressing $k ...; time bzip2 -ckd $fid > $temp; echo Moving...; echo Done; echo Moving...; mv $temp $folder/.;"
}


#decompress $1
decompress_file /work/projects/melanomics/analysis/genome/patient_2_PM/fastq/120830_SN464_0251_AD1B10ACXX_2_PM_reprep_NoIndex_L008.ft.R2_2.fastq.bz2 patient_2_PM
