
DIR=/work/projects/melanomics/analysis/genome/lumpy_genome/trim/whole_genome/
for k in 2 4 5 6 7 8
do
    pe=$DIR/patient_${k}_PM.pe.bam
    sr=$DIR/patient_${k}_PM.sr.sort.bam
    out=$DIR/patient_${k}_PM.coverages
    echo $pe $sr $out
done
