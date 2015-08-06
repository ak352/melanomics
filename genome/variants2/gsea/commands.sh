
p=4
input=/work/projects/melanomics/analysis/genome/variants2/filter/patient_$p/somatic/genes/genes.patient_$p.somatic.testvariants.annotated.rare
input=$WORK/melanomics/gsea/genes.patient_$p.somatic.testvariants.annotated.rare
python ../filter/VCF/somatic/genes/add_lengths.py $input > $input.cds_length
python get_exonic_snv_density_per_gene.py $input.cds_length > $input.cds_length.density
sed '1d' $input.cds_length.density > $input.cds_length.density.rnk

