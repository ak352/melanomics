#!/bin/bash --login
#Load pre-requisites
module load CMake/2.8.12-goolf-1.4.10
module load BioPerl/1.6.1-goolf-1.4.10-Perl-5.16.3
module load BWA/0.6.2-goolf-1.4.10
module load BLAT/3.5-goolf-1.4.10
module load Primer3/2.3.0-goolf-1.4.10
module load R/3.0.1-goolf-1.4.10-bare
export PATH=/work/projects/melanomics/tools/blast/blast-2.2.24/bin:$PATH
current=$PWD
#MEERKAT_DIR=/work/projects/melanomics/tools/meerkat
MEERKAT_DIR=/work/projects/melanomics/tools/meerkat/blcr
curr=$MEERKAT_DIR
mybamtoolsfolder=$curr/Meerkat/src/mybamtools

cd $curr
echo PWD = $PWD
#1. Build mybamtools
mybamtools()
{
    cd Meerkat/src/
    tar -jxvf mybamtools.tbz
    cd mybamtools
    mkdir build
    cd build
    cmake ..
    make
    cd $curr
}


#2. Build bamreader 
bamreader()
{
    
    cd Meerkat/src/
    tar -xjvf bamreader.tbz
    cd bamreader
    make clean
    echo ${mybamtoolsfolder}
    sed -ie "s_BTROOT = .*_BTROOT = ${mybamtoolsfolder}_g" Makefile
    make
    mv ./bamreader ../../bin
    export LD_LIBRARY_PATH=$mybamtoolsfolder/lib:$LD_LIBRARY_PATH
    #mybamtools_folder
}

#3. Build dre
dre()
{
    cd $curr
    cd Meerkat/src/
    tar -xjvf dre.tbz
    cd dre
    sed -ie "s_BTROOT = .*_BTROOT = ${mybamtoolsfolder}_g" Makefile
    make
    mv ./dre ../../bin/
}

#4. Build sclus
sclus()
{
    cd $curr
    cd Meerkat/src/
    tar -xjvf sclus.tbz
    cd sclus
    make
    mv ./sclus ../../bin
}
    


date
echo Installing Meerkat...
echo [Entering $MEERKAT_DIR]
cd $MEERKAT_DIR
#mybamtools
bamreader
dre
sclus
date 
echo Done.
echo [Leaving $MEERKAT_DIR]
cd $current
