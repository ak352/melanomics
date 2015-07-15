


download()
{
    # wget http://www.broadinstitute.org/cancer/cga/sites/default/files/data/tools/mutsig/reference_files/chr_files_hg19.zip

    wget http://www.broadinstitute.org/cancer/cga/sites/default/files/data/tools/mutsig/reference_files/mutation_type_dictionary_file.txt
    wget http://www.broadinstitute.org/cancer/cga/sites/default/files/data/tools/mutsig/reference_files/exome_full192.coverage.zip
    wget http://www.broadinstitute.org/cancer/cga/sites/default/files/data/tools/mutsig/reference_files/gene.covariates.txt

}

extract()
{
    # ls -1 *.zip
    unzip chr_files_hg19.zip
    unzip exome_full192.coverage.zip
}

mkdir -v /work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/data
pwd=$PWD
cd /work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/data

download
extract

cd $pwd

