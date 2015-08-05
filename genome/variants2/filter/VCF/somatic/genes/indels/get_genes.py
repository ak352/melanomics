from collections import Counter
import sys
refseq  ="/work/projects/melanomics/tools/annovar/db_patrick/hg19_refGene.txt.wheader"

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

def get_genes_f(refseq):
    genes = set()
    with open(refseq) as f:
        var = ParseFields(next(f))
        for line in f:
            line = line[:-1].split("\t")
            #if line[var["name"]][:2] == "NM":
            genes.add(line[var["name2"]])
    return genes

def no_p_coding_genes_f(refseq):
    no_p_coding = set()
    rnas = {}
    for record in read_tsv(refseq):
        if record['name2'] not in rnas:
            rnas[record['name2']] = set()
        rnas[record['name2']].add(record['name'])
    for rna in rnas:
        is_p_coding = False
        for name in rnas[rna]:
            if name[:2] == "NM":
                is_p_coding = True
        if not is_p_coding:
            no_p_coding.add(rna)
    return no_p_coding

def no_p_coding_genes():
    refseq0 = "/work/projects/melanomics/tools/annovar/2014Jul14/humandb/hg19_refGene.txt.wheader"
    refseq1 = "/work/projects/melanomics/tools/annovar/2014Nov12/humandb/hg19_refGene.txt.wheader"
    refseq2 = "/work/projects/melanomics/tools/annovar/2015Mar22/annovar/humandb/hg19_refGene.txt.wheader"
    # return no_p_coding_genes_f(refseq1).union(no_p_coding_genes_f(refseq2)).union(no_p_coding_genes_f(refseq))
    return set()


def get_genes():
    # refseq = "/work/projects/melanomics/tools/annovar/2014Jul14/humandb/hg19_refGene.txt.wheader"
    refseq1 = "/work/projects/melanomics/tools/annovar/2014Nov12/humandb/hg19_refGene.txt.wheader"
    refseq2 = "/work/projects/melanomics/tools/annovar/2015Mar22/annovar/humandb/hg19_refGene.txt.wheader"
    return get_genes_f(refseq)
    #return get_genes_f(refseq1).union(get_genes_f(refseq2))

    

def get_longest_gene_f(refseq):
    lengths = {}
    for record in read_tsv(refseq):
        name2 = record["name2"]
        length = int(record["txEnd"]) - int(record["txStart"])
        if name2 in lengths:
            if length <= lengths[name2]:
                continue
        lengths[name2] = length
    return lengths

def get_longest_gene():
    get_longest_gene_f(refseq)


def get_symbols(sym_file):
    symbols = {}
    for line in open(sym_file):
        line = line[:-1].split("\t")
        gene = line[1][2:-2]
        rna = line[0]
        if gene not in symbols:
            symbols[gene] = []
        symbols[gene].append(rna)
    return symbols

def get_longest_exome_f(refseq):
    cds = {}
    for line in open(refseq):
        line = line[:-1].split("\t")
        rna = line[0]
        length = int(line[1])
        if rna in cds:
            if cds[rna] < length:
                cds[rna] = length
        else:
            cds[rna] = length
    return cds

def get_longest_exome():
    refseq_cds="/work/projects/melanomics/data/refseq/human.cds.corrected.fa.fai"
    sym_file="/work/projects/melanomics/data/refseq/gene_symbols"
    rna2length =  get_longest_exome_f(refseq_cds)
    gene2rna = get_symbols(sym_file)
    
    counter  = Counter()
    gene2length = {}
    for gene in gene2rna:
        for rna in gene2rna[gene]:
            if rna not in rna2length:
                counter['no_length'] += 1
                continue    
            if gene in gene2length:
                if rna2length[rna] > gene2length[gene]:
                    gene2length[gene] = rna2length[rna]
            else:
                gene2length[gene] = rna2length[rna]

    for key in counter:
        sys.stderr.write("Number of %s = %d\n" % (key, counter[key]))
    return gene2length

            
