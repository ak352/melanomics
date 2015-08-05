### Compare RNA SNVs/indels to DNA variants SNVs/indels

#### Steps
1. Set the ```patient``` name and ```dna_sample``` in ```commands.sh```. Set the ```OUTDIR``` output directory.
2. Run ```./commands.sh```, which contains the following functions -
 * ```extract_dna``` extracts the DNA tumor sample sequence of the patient
 * ```prepare_rna``` bgzip compresses and indexes the RNA SNV VCF file
 * ```norm``` left-normalises indels
 * ```compare``` compares the RNA SNVs with the DNA SNVs
3. The output statistics is in ```$OUTDIR/$dna_sample.dna.rna.stats```


