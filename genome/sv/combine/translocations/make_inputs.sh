
for k in 2 4 5 6 7 8
do
    output=patient_${k}.inputs 
    echo patient_${k}_delly /work/projects/melanomics/analysis/genome/sv/delly/patient_${k}/final/patient_${k}_PM.TRA.testvariants.intervals > $output
    echo patient_${k}_lumpy /work/projects/melanomics/analysis/genome/lumpy_genome/trim/patient_${k}.TRA.testvariants.intervals >> $output
    echo Inputs written to $output
done

