    # INDIR=/work/projects/melanomics/analysis/genome/variants2/mutsigcv/
    # OUTDIR=$INDIR
    # DATADIR=/work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/data/
    # ls $DATADIR/
    # maf=$INDIR/somatic.sorted.maf
    # cov=$DATADIR/exome_full192.coverage.txt
    # gen=$DATADIR/gene.covariates.txt
    # out=$OUTDIR/somatic.output.txt
    # dic=$DATADIR/mutation_type_dictionary_file.txt
    # chrom=/work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/data/ncbi
    # #head -n2 $maf| sed 's/\t/\n/g'
    # #head $maf

    # python check_ref.py $maf $chrom

import pysam
#Creates a dictionary of fields pointing to column numbers, makes the code more readable
def ParseFields(line):
    fields = {}
    var = line[:-1].split("\t")
    for x in range(0, len(var)):
        fields[var[x]] = x
    return fields

def read_tsv(infile):
    with open(infile) as f:
        var = ParseFields(next(f))
        
        for line in f:
            record = {}
            line = line[:-1].split("\t")
            for x in var:
                record[x] = line[var[x]]
            record["all"] = "\t".join(line)
            yield record

def get_ref(fasta, loc):
    return


if __name__ == "__main__":
    maf="/work/projects/melanomics/analysis/genome/variants2/mutsigcv/somatic.sorted.maf"
    ref="/work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4/data/ncbi/chr{0!s}.txt"
    print(ref.format(1))
    ref="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa"
    
    fasta = pysam.Fastafile(ref)

    num_same = 0
    num_diff = 0
    
    with open(maf) as f:
        print(next(f)[:-1])
    for record in read_tsv(maf):
        chrom = record["Chromosome"]
        start = record["Start_position"]
        stop = record["End_position"]
        reference = record["Reference_Allele"]
        #print(chrom, int(start), int(stop), reference)
        ref_maf = reference
        ref_fa = fasta.fetch(chrom, int(start), int(stop))
        if ref_maf == ref_fa:
            num_same += 1
        else:
            num_diff += 1
print("Number of same reference genotypes = %d\n" % num_same)
print("Number of different reference genotypes = %d\n" % num_diff)

            

    
