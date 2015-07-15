## Annotate CNVs

### Prepare input files
The input CNV file is a tab-separated file with the headers "chrom", "begin", "end", "ploidy"

### Annotation
1. Run ```./commands.sh``` to annotate with DGV 
2. Run ```./annotate.sh``` to annotate with genes and to optionally get per gene average copy number
3. The output of ```./annotate.sh``` can then be used as input for the ```get_cnv.py``` in the ```variants2/hotnet2/matrix/mutation/``` directory for the HotNet2 pipeline.



