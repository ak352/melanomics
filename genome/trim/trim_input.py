import os
import sys
import re

def mkdir(out_dir):
	if not os.path.isdir(out_dir):
		os.makedirs(out_dir)


def fastq_fastqc(input_prefix, output_dir):
    #output_dir = "patient_2/adapter_quality_filter_trim/"
    #input_prefix = "patient_2/FastQC/120827_SN386_0256_BC16NGACXX_RNA_4_PM_CCGTCC_L00"
    #Lanes 5,6,7,8
    #for x in range(5,9)
    #Lanes
	for x in range(1,9):
		line = []
		prefixes = []
		mates = [0]*8
		for y in range(1,3):
			prefixes.append(input_prefix+str(x)+".ft.R"+str(y)+"_"+str(y))
		for prefix in prefixes:
			fastq = re.sub('fastqc', 'fastq', prefix)+".fastq" 
			line.append(fastq)
		for prefix in prefixes:
			fastqc = prefix+"_fastqc/fastqc_data.txt"
			if os.path.isfile(fastqc):
				line.append(fastqc)
				mates[y] += 1
		for k in range(len(mates)):
			if mates[k]%2:
				sys.stderr.write("WARNING: Odd number of mates in lane " + str(k) + "\n")
				
		mkdir(output_dir)
		line.append(output_dir)
		if sum(mates):
			print " ".join(line)

def usage():
	return "Usage: python trim_input.py <base_dir> <sample_read_prefix> <output_prefix>\n" + \
	    "Example: python trim_input.py /work/projects/melanomics/analysis/genome/ " + \
	    "NHEM/fastqc/120827_SN386_0257_AC13YAACXX_NHEM_reprep_NoIndex_L00 NHEM/trim\n"

if __name__ == "__main__":
    if len(sys.argv) == 1:
	    base_dir="/work/projects/melanomics/analysis/genome/"
	    out_dir = "/work/projects/melanomics/analysis/genome/"
	    mkdir(out_dir)
	    samples = []
            #for line in open("fastqc_files_1_34_wo_4PM"):
            #for line in open("fastqc_files_1_34"):
	    #for line in open("fastqc_files_35_48"): 
	    #for line in open("test_fastqc_files2"): 
	    for line in open("fastqc_files"):
		    samples.append(line.rstrip())

	    for k in range(0, len(samples), 2):
		    samples[k] = base_dir + samples[k]
	    for k in range(1, len(samples), 2):
		    samples[k] = out_dir + samples[k]
	    for x in range(0, len(samples), 2):
		    fastq_fastqc(samples[x], samples[x+1])
    elif len(sys.argv) > 1:
	    if len(sys.argv) == 4:
		    base_dir = sys.argv[1]
		    out_dir  = os.environ['$SCRATCH'] + "/"
		    samples  = [sys.argv[2:4]]
		    fastq_fastqc(samples[0], samples[1])
	    else:
		    sys.stderr.write(str(len(sys.argv)) + " arguments.\n")
		    sys.stderr.write(usage())



 
	    
