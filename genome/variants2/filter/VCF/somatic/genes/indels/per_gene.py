import sys
#import pandas as pd
from get_genes import get_genes, no_p_coding_genes
import json

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
            

def report(line, log):
    for s in sys.stderr, log:
        s.write(line)

if __name__ == "__main__":
    infile = sys.argv[1]
    outfile = sys.argv[2]
    cnv_file = sys.argv[3] #"/work/projects/melanomics/analysis/genome/abscnseq/vs2_min1000/P2.vs2.wheader.dgv.genes"
    cnvs = json.load(open(cnv_file))
    logfile = outfile + ".log"
    not_found_file = outfile + ".genes_not_found_refseq.log"
    out, log, genes_not_found = [open(x, "w") for x in [outfile, logfile, not_found_file]]

    report("Input: %s\n" % infile, log)
    report("Output: %s\n" % outfile, log)
    report("Log file: %s\n" % logfile, log)
    report("List of genes not found in RefSeq: %s\n" % not_found_file, log)
    



    genes = get_genes()
    no_protein_coding_genes = no_p_coding_genes()
    # genes.add("NONE")
    annotations = [line[:-1] for line in open("func_annotations")]
    exonic_annotations = [line[:-1] for line in open("exonic_func_annotations")]
    exonic_annotations.extend(annotations)
    annotations = exonic_annotations

    not_found_genes=set()

    funcs = {}
    for gene in genes:
        funcs[gene] = [0]*len(annotations)

    out.write("hgnc_symbol\t%s\n" % "\t".join(annotations))
    
        
    for record in read_tsv(infile):
        curr_genes = record["Gene.refGene"].split(";")
        curr_funcs = record["Func.refGene"].split(";")
        exonic_func = record["ExonicFunc.refGene"]
        assert ";" not in exonic_func
        assert "," not in exonic_func
        
        
        for i,func in enumerate(curr_funcs):
            if func not in annotations:
                report("Function %s not found in reference list of annotations\n" % annotations, log)
                continue
        
            for gene in curr_genes[i].split(","):
                if gene not in genes:
                    #report("Gene %s not found in RefSeq\n" % gene, log)
                    if gene not in no_protein_coding_genes:
                        not_found_genes.add(gene)
                    continue
                funcs[gene][annotations.index(func)] += 1

                """ Exonic annotation count """
                if func == "exonic":
                    funcs[gene][annotations.index(exonic_func)] += 1



    for gene in sorted(genes):
        counts = "\t".join([str(s) for s in funcs[gene]])
        out.write("%s\t%s\n" % (gene, counts))
        

    for gene in sorted(not_found_genes):
        genes_not_found.write("%s\n" % gene)

    report("[WARN] %d genes in annotated variants file not found in RefSeq database any more and are excluded from the statistics\n" % len(not_found_genes), log)

