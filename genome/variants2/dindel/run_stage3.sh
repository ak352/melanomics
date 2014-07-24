
run()
{
    varFile=$WINDOW_DIR/$sample.realign_windows.$num.txt
    libFile=${output_prefix}.dindel_output.libraries.txt
    echo Number of window files generated = $num
    outputFile=$WINDOW_DIR/$sample.dindel_stage2_output_windows.$num
    
    dindel --analysis indels \
	--bamFile $bam \
	--ref $ref \
	--varFile $varFile \
	--libFile $libFile \
	--outputFile $outputFile
}