download()
{
    wget http://www.broadinstitute.org/cancer/cga/sites/default/files/data/tools/mutsig/MutSigCV_example_data.1.0.1.zip
}

extract()
{
    unzip MutSigCV_example_data.1.0.1.zip
}


run_test()
{
    module load base/MATLAB/2013a

    INDIR=/work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/example/MutSigCV_example_data.1.0.1
    #ls -1 $INDIR
    mcrpath=/opt/apps/resif/devel/v1.1-20150414/core/software/base/MATLAB/2013a
    mutsig=/work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/run_MutSigCV.sh
    maf=$INDIR/LUSC.mutations.maf
    cov=$INDIR/LUSC.coverage.txt
    gen=$INDIR/gene.covariates.txt
    out=$INDIR/LUSC.output.txt
    dic=/work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/data/mutation_type_dictionary_file.txt
    #head -n2 $maf| sed 's/\t/\n/g'
    #head $maf
    
    $mutsig $mcrpath $maf $cov $gen $out $dic

}

# mkdir -v /work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/example
# pwd=$PWD
# cd /work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/example
# download
# extract
# cd $pwd

run_test
# wc -l  /work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/example/MutSigCV_example_data.1.0.1/LUSC.output.txt.sig_genes.txt


