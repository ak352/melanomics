#!/bin/bash --login
module load lang/Python/2.7.5-ictce-5.3.0
module load pysam
# ls /work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/data
# head /work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/data/exome_full192.coverage.txt
# head /work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/data/gene.covariates.txt


maflite()
{
    input=/work/projects/melanomics/analysis/genome/variants2/filter/patient_2/somatic/patient_2.somatic.testvariants.annotated.rare
    OUTDIR=/work/projects/melanomics/analysis/genome/variants2/mutsigcv/
    mkdir -v $OUTDIR
    output=$OUTDIR/somatic.maf

    python tv2maf.py > $output

    (head -n1 $output; sed '1d' $output | sort;) > ${output%%maf}sorted.maf
    wc -l $output
    head $output
    tail $output
}

mutsig()
{
    module load base/MATLAB/2013a
    mcrpath=/opt/apps/resif/devel/v1.1-20150414/core/software/base/MATLAB/2013a
    mutsig=/work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/run_MutSigCV.sh
    INDIR=/work/projects/melanomics/analysis/genome/variants2/mutsigcv/
    OUTDIR=$INDIR
    DATADIR=/work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/data/
    ls $DATADIR/
    maf=$INDIR/somatic.sorted.maf
    cov=$DATADIR/exome_full192.coverage.txt
    gen=$DATADIR/gene.covariates.txt
    out=$OUTDIR/somatic.output.txt
    dic=$DATADIR/mutation_type_dictionary_file.txt
    # chrom=/work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/data/ncbi
    chrom=/work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/data/chr_files_37
    #head -n2 $maf| sed 's/\t/\n/g'
    #head $maf

    #python check_ref.py $maf $chrom
    $mutsig $mcrpath $maf $cov $gen $out $dic $chrom
    

}


test_var()
{
    maf=$INDIR/test.maf
    cov=$DATADIR/test.coverage.txt

}

maflite
mutsig
#head /mnt/gaiagpfs/projects/melanomics/tools/oncotator/oncotator-1.5.1.0/test/testdata/maflite/Patient0.snp.maf.txt

