import sys
#fastqc_file = "/work/projects/melanomics/analysis/transcriptome/patient_2/FastQC/120827_SN386_0256_BC16NGACXX_RNA_4_PM_CCGTCC_L005.ft.R1_1_fastqc/fastqc_data.txt"

fastqc_file = sys.argv[1]

fd = open(fastqc_file)
while not fd.next().startswith(">>Overrepresented"):
    pass
fd.next()
line = fd.next()

seqs = set()
while not line.startswith(">>"):
    seqs.add(line.strip().split("\t")[0])
    line = fd.next()
    
for x in seqs:
    print x




