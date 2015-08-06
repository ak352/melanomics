#!/bin/bash --login


module load SAMtools
module load BEDTools
source ../paths

retroseq="/work/projects/melanomics/tools/retroseq/RetroSeq/bin/retroseq.pl"

bam=test.bam
output=test.out
eref=/work/projects/melanomics/data/repeatMasker/sanger/Example/probes.tab
refte=/work/projects/melanomics/data/repeatMasker/sanger/Example/ref_types.tab
/work/projects/melanomics/tools/retroseq/RetroSeq/bin/retroseq.pl -discover -bam $bam -output $output -eref $eref -refTRs $refte -align -len 10

# echo "Run retroseq discovery phase"
# date
# CMD="${retroseq} \                                                                                                                                                                                                                            -discover \                                                                                                                                                                                                                           -bam ${bam} \                                                                                                                                                                                                                         -output ${output}"
# echo "${CMD}"
# eval "time ${CMD}"
# date
# echo "Finished discovery phase using retroseq."



