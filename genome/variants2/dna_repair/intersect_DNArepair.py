import sys
import re

def get_gene_intersection(data_file, gene_list, out_file):

    data = open(data_file, 'r')
    g = open(gene_list, 'r')
    out = open(out_file, 'w')
    header = data.readline()
    header_fields = header.strip('\n').split('\t')
    gene_idx = header_fields.index('Gene.refGene')

    genes = []
    for gene in g:
	genes.append(gene.strip())

    out.write(header)

    for line in data:
        gene = line.split('\t')[gene_idx]
	if gene in genes:
	    out.write(line)
	
    data.close()
    g.close()
    out.close()

if __name__ == '__main__':
    data = sys.argv[1]
    genes = sys.argv[2]
    out = sys.argv[3]
    get_gene_intersection(data, genes, out)
