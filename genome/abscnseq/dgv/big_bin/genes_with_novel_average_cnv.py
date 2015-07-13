import csv
import sys
import math



def has_dgv(string):
    strings = string.split(";")
    for s in strings:
        s = s.split(":")
        if s[0]=="y" and int(s[1])>50:
            return True
    return False

def get_affected_genes(infile, log):
    affected_genes = set()
    num_genes, num_genes_not_in_dgv,total_genes_novel_cnv = 0,0,0
    
    with open(infile) as csvfile:
        f = csv.DictReader(csvfile, delimiter='\t')
        for row in f:
            # print(row.keys())
            # print row
            num_genes += 1
            genes = row['>name2']
            ratio = float(row[' mean_NS_PM_ratio'])
            dgv = row['found_in_dgv']
            if has_dgv(dgv):
                num_genes_not_in_dgv += 1
                if ratio <= -1 or ratio >= 1:
                    total_genes_novel_cnv += 1
                    for gene in genes.split(";"):
                        gene = gene.split(":")[0]
                        affected_genes.add(gene)

    report('Total number of genes = %d\n' % num_genes, log)
    report('Genes with < 50%% overlap with a DGV variant = %d\n' % num_genes_not_in_dgv, log)
    report('Genes with < 50%% overlap with DGV, which have a gain/loss = %d\n' % total_genes_novel_cnv, log)
    return affected_genes

                        
def report(line, log):
    for s in sys.stderr, log:
        s.write(line)

def write_affected_genes(infile):
    outfile = infile + ".average_affected_genes"
    logfile = outfile + ".log"
    out = open(outfile, 'w')
    log = open(logfile, 'w')
    
    #report("Input: %s\n" % infile, log)
    #report("Output: %s\n" % outfile, log)
    #report("Log file: %s\n" % logfile, log)
    
    
    affected_genes = get_affected_genes(infile, log)

    for gene in sorted(affected_genes):
        out.write(gene+"\n")


if __name__ == "__main__":
    samples = [2,4,6,7,8]
    infiles = ["/work/projects/melanomics/analysis/genome/abscnseq/P%d.cnv.adj.called.wheader.dgv.per_gene.mean" % s for s in samples]
    for infile in infiles:
        write_affected_genes(infile)
