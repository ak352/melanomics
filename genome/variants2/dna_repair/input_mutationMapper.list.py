#! /usr/bin/python

import sys
import re

def get_mutationMapper_input(data_file, gene_list, nm_list, out_file):
	# open files
	data = open(data_file, 'r')
	g = open(gene_list, "r")
	n = open(nm_list, "r")
	out = open(out_file, 'w')
    
	newcontent = 'Hugo_Symbol\tSample_ID\tProtein_Change\tMutation_Type\tChromosome\tStart_Position\tEnd_Position\n'
	# write the header in the new file
	out.write(newcontent)
    
	header = data.readline()
	# split the header into columns
	header_fields = header.strip('\n').split('\t')
	 # get the gene index from the header
	variant_idx = header_fields.index('ExonicFunc.refGene')
	vartype_idx = header_fields.index('Func.refGene')
	chromosome_idx = header_fields.index('chromosome')
	start_idx = header_fields.index('begin')
	end_idx = header_fields.index('end')
	iso_idx = header_fields.index('AAChange.refGene')
	gene_idx = header_fields.index('Gene.refGene')
	patient = [s for s in header_fields if s.startswith("patient")][0]   

	genes = []
	for gene in g:
		genes.append(gene.strip())
	
	nms = []
	for nm in n:
		nms.append(nm.strip())    

	for line in data:
		line = line.strip('\n').split('\t')
		
		### splicing OR exonic
                vartype_inp = line[vartype_idx]
		
		## splicing
                #if vartype_inp == "splicing":
		#PROBLEM TO GET AA for splice sites!!! TO DO!!
		
		## exonic
		if vartype_inp == "exonic":
			
			## genes of interest
			gene_inp = line[gene_idx]
			#print gene_inp
			if gene_inp not in genes:
				print gene_inp + " is NOT in genes"
			if gene_inp in genes:
				print gene_inp + " is in genes"
				variant = line[variant_idx]
				print variant
				if not variant or variant == "UNKNOWN" :
					continue
				print variant
			
				## NMids form genes of interest
					
				transcript_inp = line[iso_idx]
				if not transcript_inp or transcript_inp == "UNKNOWN":
					continue
				change_list = transcript_inp.strip('"').split(',')	
				for change in change_list:
           		 		nm_inp = change.split(":")[1]		
					if nm_inp not in nms:
						print nm_inp + " is NOT in nms"
					if nm_inp in nms:
						print nm_inp + " is in nms"
						protein_inp = change.split(':')[4]
						print protein_inp
						if not protein_inp or protein_inp == "":
							print protein_inp + " No AA change"
						protein = protein_inp.split(".")
						print protein
						aa = protein[1]
						print aa
						print aa[0]
						print aa[-1]
						if aa[0] == aa[-1]:
							print aa + " Not a non-synomymous SNV"
						chromosome = line[chromosome_idx]
						start = line[start_idx]
						end = line[end_idx]
						gene = line[gene_idx]
						newline = "\t".join([gene, patient, aa, variant, chromosome, start, end])
						newcontent += newline + "\n"

	# open a new file object for writing
	out = open(out_file, 'w')
	# write the new content to the ouptut file
	out.write(newcontent)

	# close files
	data.close()
	g.close()
	n.close()
	out.close()

if __name__ == '__main__':
	#   python script.py myData.txt gene_list.txt output.txt
	data = sys.argv[1]
	genes = sys.argv[2]
	nms = sys.argv[3]
	out = sys.argv[4]
	get_mutationMapper_input(data, genes, nms, out)
