
def fastq_fastqc(input_prefix, output_dir):
    #output_dir = "/work/projects/melanomics/analysis/transcriptome/patient_2/adapter_quality_filter_trim/"
    #input_prefix = "/work/projects/melanomics/analysis/transcriptome/patient_2/FastQC/120827_SN386_0256_BC16NGACXX_RNA_4_PM_CCGTCC_L00"
    for x in range(5,9):
        line = []
        prefixes = []
        for y in range(1,3):
            prefixes.append(input_prefix+str(x)+".ft.R"+str(y)+"_"+str(y))
        for prefix in prefixes:
            fastq = prefix+".fastq" 
            line.append(fastq)
        for prefix in prefixes:
            fastqc = prefix+"_fastqc/fastqc_data.txt"
            line.append(fastqc)
        line.append(output_dir)
        print " ".join(line)

if __name__ == "__main__":
    base_dir="/work/projects/melanomics/analysis/transcriptome/"
    samples = ["/work/projects/melanomics/analysis/transcriptome/patient_2/FastQC/120827_SN386_0256_BC16NGACXX_RNA_4_PM_CCGTCC_L00", \
                   "/work/projects/melanomics/analysis/transcriptome/patient_2/adapter_quality_filter_trim/", \
                   "/work/projects/melanomics/analysis/transcriptome/patient_4/NS/FastQC/120827_SN386_0256_BC16NGACXX_RNA_1_NS_AGTTCC_L00", \
                   "/work/projects/melanomics/analysis/transcriptome/patient_4/NS/adapter_quality_filter_trim/", \
                   "/work/projects/melanomics/analysis/transcriptome/patient_4/PM/FastQC/120827_SN386_0256_BC16NGACXX_RNA_1_PM_ATGTCA_L00", \
                   "/work/projects/melanomics/analysis/transcriptome/patient_4/PM/adapter_quality_filter_trim/", \
                   "/work/projects/melanomics/analysis/transcriptome/patient_6/FastQC/120827_SN386_0256_BC16NGACXX_RNA_6_PM_GTCCGC_L00", \
                   "/work/projects/melanomics/analysis/transcriptome/patient_6/adapter_quality_filter_trim/", \
                   "/work/projects/melanomics/analysis/transcriptome/NHEM/FastQC/120827_SN386_0256_BC16NGACXX_RNA_NHEM_CGATGT_L00", \
                   "/work/projects/melanomics/analysis/transcriptome/NHEM/adapter_quality_filter_trim/", \
                   "/work/projects/melanomics/analysis/transcriptome/pool/FastQC/120827_SN386_0256_BC16NGACXX_RNA_pool_3_7_NS_GTGAAA_L00", \
                   "/work/projects/melanomics/analysis/transcriptome/pool/adapter_quality_filter_trim/"]
                   
    for x in range(0, len(samples), 2):
        fastq_fastqc(samples[x], samples[x+1])

    
        
