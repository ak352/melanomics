#! /usr/bin/python

import sys
import re

def get_gene_intersection(data_file, gene_list, out_file):

    # open files
    data = open(data_file, 'r')
    g = open(gene_list, 'r')
    out = open(out_file, 'w')

    #write to new file and add header 
    newcontent = 'gene\tcancer_type\tsample_id\tposition\twt_residue\tmut_residue\n'
    out.write(newcontent)

    header = data.readline()
    # split the header into columns
    header_fields = header.strip('\n').split('\t') 
    # get the gene index from the header
    iso_idx = header_fields.index('AAChange.refGene')
    gene_idx = header_fields.index('Gene.refGene')
    patient = [s for s in header_fields if s.startswith('patient')][0]

    genes =[]
    for gene in g:
        genes.append(gene.strip())
    
    pat = re.compile('\d+')
    
    for line in data:
        line = line.strip('\n').split('\t')
        #print line
        transcript_inp = line[iso_idx]
        #print transcript_inp
        if not transcript_inp or transcript_inp == "UNKNOWN":
            continue
	change_list = transcript_inp.strip('"').split(',')
        #print change_list
	for change in change_list:
	    iso = change.split(":")[1]
	    #print iso
	    if iso not in genes:
		print iso + " is NOT in genes"
	    if iso in genes:
		print iso + " is in genes"
		protein = change.split(':')[4]
		#print protein
		m = re.search(pat,protein)
		position = m.group()
		wt_residue = protein[m.start()-1]
		#print wt_residue
		mut_residue = protein[m.end()]
		#print mut_residue
		cancer_type = 'melanoma' 
		gene = line[gene_idx]
        
	newline = '\t'.join([gene, cancer_type, patient, position, wt_residue, mut_residue]) 
    
        newcontent += newline + '\n'
        
    out = open(out_file, 'w')
    out.write(newcontent)
    out.close()
        
    data.close()
    g.close()
    out.close()

if __name__ == '__main__':
    data = sys.argv[1] 
    genes = sys.argv[2]
    out = sys.argv[3]
    get_gene_intersection(data, genes, out)
