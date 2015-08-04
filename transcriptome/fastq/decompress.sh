#!/bin/bash --login
module load bzip2

decompress()
{
    sample=$1
    echo Decompressing $sample
    folder=/work/projects/melanomics/analysis/genome/$sample
    for k in $folder/*.bz2
    do
	bzip2 -ckd $k > ${k%.bz2}
    done
    echo Decompression done.
}

decompress $1
