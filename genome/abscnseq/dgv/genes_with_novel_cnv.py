import csv
import sys
import math

def has_dgv(string):
    if not string:
        return False
    strings = string.split(";")
    for s in strings:
        s = s.split(":")
        if int(s[1])>50:
            return True
    return False

def get_affected_genes(infile, log):
    affected_genes = set()
    num_rows, num_cnv, num_cnv_novel, num_cnv_novel_genes, total_genes_novel_cnv = 0,0,0,0,0
    
    with open(infile) as csvfile:
        f = csv.DictReader(csvfile, delimiter='\t')

        sum_ploidy = 0
        sum_bins = 0
        
        for row in f:
            # print(row.keys())
            size = int(row['end'])-int(row['begin'])
            ploidy = float(row['ploidy'])
            sum_ploidy += math.exp(ploidy) * size
            sum_bins += size

            dgv = row['variantaccession']
            genes=row['name2']
            num_rows += 1
            if ploidy <= -1 or ploidy >= 1:
                num_cnv += 1
                if not has_dgv(dgv):
                    num_cnv_novel += 1
                    if genes:
                        num_cnv_novel_genes += 1
                        # print(ploidy, genes)
                        for gene in genes.split(";"):
                            affected_genes.add(gene.split(":")[0])
    total_genes_novel_cnv += len(affected_genes)
    average_ploidy = math.log(sum_ploidy/sum_bins)

    report('Total number of bins = %d\n' % num_rows, log)
    report('Number of bins with CNVs (adjusted log ratio <=-1 or >= 1) = %d\n' % num_cnv, log)
    report('Number of bins with novel CNVs = %d\n' % num_cnv_novel, log)
    report('Number of bins with novel CNVs and genes = %d\n' % num_cnv_novel_genes, log)
    report('Number of genes containing novel CNVs = %d\n' % total_genes_novel_cnv, log)
    report('Average ploidy = %2.3f\n' % average_ploidy, log)
    
    return affected_genes

def report(line, log):
    for s in sys.stderr, log:
        s.write(line)

def write_affected_genes(infile):
    outfile = infile + ".affected_genes"
    logfile = outfile + ".log"
    out = open(outfile, 'w')
    log = open(logfile, 'w')
    
    report("Input: %s\n" % infile, log)
    report("Output: %s\n" % outfile, log)
    report("Log file: %s\n" % logfile, log)
    
    
    affected_genes = get_affected_genes(infile, log)

    for gene in sorted(affected_genes):
        out.write(gene+"\n")


        
if __name__ == "__main__":
    samples = [2,4,6,7,8]
    #samples = [8]
    #infiles = ["/work/projects/melanomics/analysis/genome/abscnseq/P%d.cnv.adj.called.wheader.dgv.genes" % s for s in samples]
    infiles = ["/work/projects/melanomics/analysis/genome/abscnseq/vs2/P%d.vs2.wheader.dgv.genes" % s for s in samples]
    for infile in infiles:
        write_affected_genes(infile)
        
