#!/bin/bash --login
module load cgatools

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


## Use only the COSMIC mutations that are "Confirmed somatic variants"
## Use only the COSMIC mutations that have a genomic location
edit_cosmic()
{
    input=/work/projects/melanomics/data/cosmic/CosmicCompleteExport.tsv
    output1=${input%%tsv}edited.tsv
    output2=${input%%tsv}edited.skin.tsv

    # python cosmic_locations.py $input > $output1
    # out_status $output1
    cut -f26 $output1 | sed '1d' | grep -vP '^$' | sed 's/;/\n/g' | sort -un > $output1.pmids
    out_status $output1.pmids
    # python cosmic_skin.py $input > $output2
    # out_status $output2
    cut -f26 $output2 | sed '1d' | grep -vP '^$' | sed 's/;/\n/g' | sort -un > $output2.pmids
    out_status $output2.pmids
}

cosmic_anno()
{
    k=$1
    sample=patient_${k}
    OUTDIR=/work/projects/melanomics/analysis/genome/variants2/filter/$sample/cosmic
    mkdir -v $OUTDIR
    input1=/work/projects/melanomics/analysis/genome/variants2/filter/$sample/$sample.somatic.testvariants.annotated
    cosmic=/work/projects/melanomics/data/cosmic/CosmicCompleteExport.edited.tsv
    output=$OUTDIR/${input1##*/}.cosmic
    status "Annotating with COSMIC..."
    cgatools join --beta --match chromosome:chrom --overlap begin,end:begin,end \
	-a --select A.*,B."Accession Number",B."Primary site",B.Pubmed_PMID \
	-m compact --input $input1 $cosmic >  $output
    out_status $output
}


cosmic_skin_anno()
{
    k=$1
    sample=patient_${k}
    OUTDIR=/work/projects/melanomics/analysis/genome/variants2/filter/$sample/cosmic
    mkdir -v $OUTDIR
    input1=/work/projects/melanomics/analysis/genome/variants2/filter/$sample/$sample.somatic.testvariants.annotated
    cosmic=/work/projects/melanomics/data/cosmic/CosmicCompleteExport.edited.skin.tsv
    output=$OUTDIR/${input1##*/}.cosmic.skin
    status "Annotating with COSMIC..."
    cgatools join --beta --match chromosome:chrom --overlap begin,end:begin,end \
	-a --select A.*,B."Accession Number",B."Primary site",B.Pubmed_PMID \
	-m compact --input $input1 $cosmic >  $output
    out_status $output
}


stats()
{
    k=$1
    sample=patient_${k}
    INDIR=/work/projects/melanomics/analysis/genome/variants2/filter/$sample/cosmic
    input=$INDIR/$sample.somatic.testvariants.annotated.cosmic
    output=$input.stats

    python stats.py $input > $output
    
    echo $sample
    cat $output
}

skin_stats()
{
    k=$1
    sample=patient_${k}
    INDIR=/work/projects/melanomics/analysis/genome/variants2/filter/$sample/cosmic
    input=$INDIR/$sample.somatic.testvariants.annotated.cosmic.skin
    output=$input.skin.stats

    python stats.py $input > $output
    
    echo $sample
    cat $output
}



edit_cosmic
#for k in 2 4 5 6 7 8
#do
    #cosmic_anno $k
    #stats $k
    #cosmic_skin_anno $k
    #skin_stats $k
    
#done

