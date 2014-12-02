
for k in 2 4 5 6 7 8
do
    for sv in DUP INV TRA
    do
	ind=patient_${k}
	normal=${ind}_NS
	tumor=${ind}_PM
	normal_bam=/work/projects/melanomics/analysis/genome/$normal/bam/$normal.bam
	tumor_bam=/work/projects/melanomics/analysis/genome/$tumor/bam/$tumor.bam
	OUTDIR=/work/projects/melanomics/analysis/genome/sv/delly/$ind
	
	#mkdir /work/projects/melanomics/analysis/genome/sv/delly/$ind/run1
	#mv /work/projects/melanomics/analysis/genome/sv/delly/$ind/* /work/projects/melanomics/analysis/genome/sv/delly/$ind/run1/. 
	echo $ind $normal_bam $tumor_bam $OUTDIR $sv
    done
done


