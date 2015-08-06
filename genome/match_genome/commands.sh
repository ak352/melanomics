#!/bin/bash --login
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

match()
{
    #input=/work/projects/melanomics/analysis/genome/variants2/all.dna.coverage_annotated.testvariants
    input=/work/projects/melanomics/analysis/genome/variants2/filter/all.filter_annotation.out
    #output=/work/projects/melanomics/analysis/genome/variants2/filter/match_genome/matches.filtered
    output=/work/projects/melanomics/analysis/genome/variants2/filter/match_genome/matches.filtered.pc_intersect_union
    status "Matching normal with tumor genomes..."
    python matches.py $input > $output
    out_status $output

}

match_hapmap()
{
    input=/work/projects/melanomics/analysis/genome/variants2/filter/all.filter_annotation.out
    hapmap_variantids=/work/projects/melanomics/analysis/genome/variants2/filter/hapmap.variantIds
    #output=/work/projects/melanomics/analysis/genome/variants2/filter/match_genome/matches.filtered
    output=/work/projects/melanomics/analysis/genome/variants2/filter/match_genome/matches.filtered.hapmap.pc_intersect_union
    status "Matching normal with tumor genomes..."
    python match_hapmap.py $input $hapmap_variantids > $output
    out_status $output

}

match_hapmap2()
{
    input=/work/projects/melanomics/analysis/genome/variants2/plink/hapmap/all.filter_annotation.out.hapmap.variants
    output=/work/projects/melanomics/analysis/genome/variants2/filter/match_genome/matches.filtered.hapmap2.pc_intersect_union
    status "Matching normal with tumor genomes..."
    python matches.py $input > $output
    out_status $output
}


#match
#match_hapmap
#match_hapmap2

output=/work/projects/melanomics/analysis/genome/variants2/filter/match_genome/matches.filtered.hapmap2.pc_intersect_union
cat $output



