
input=/work/projects/melanomics/analysis/genome/variants2/filter/patient_8/germline/patient_8.testvariants.filter.annotated.germline
output=/work/projects/melanomics/analysis/genome/variants2/filter/dna_repair/patient_8.germline.rare.aachanging.DNArepair.mutationMapper.longestNM.test.txt
longest=/work/projects/melanomics/analysis/genome/variants2/longest_transcript/refseq_longest_transcripts

python input_mutationMapper.py $input $longest $output
