import sys

def clean_fastq(infile, outfile):
    
    print("Input: %s" % infile)
    print("Output: %s" % outfile)
    out = open(outfile, 'w')
    num_reads = 0
    with open(infile) as f:
        while True:
            try:
                line = next(f)[:-1]
                if line[:4]=='@BUT' or line[:3]=='@HW':
                    line1 = line
                    line = next(f)[:-1]
                    num_reads += 1
                    out.write('>' + line1 + '\n')
                    out.write(line + '\n')


            except StopIteration:
                break
    sys.stderr.write('Number of reads = %d\n' % num_reads)

if __name__ == '__main__':
    fq1 = '/work/projects/melanomics/analysis/igv/ctdsp2_mutation/raw_fastq/patient_2_NS.1_1.fastq'
    fq2 = '/work/projects/melanomics/analysis/igv/ctdsp2_mutation/raw_fastq/patient_2_NS.2_2.fastq'

    output1 = '/work/projects/melanomics/analysis/igv/ctdsp2_mutation/raw_fastq/fasta/patient_2_NS.1_1.fasta'
    output2 = '/work/projects/melanomics/analysis/igv/ctdsp2_mutation/raw_fastq/fasta/patient_2_NS.2_2.fasta'
    
    clean_fastq(fq1, output1)
    clean_fastq(fq2, output2)

