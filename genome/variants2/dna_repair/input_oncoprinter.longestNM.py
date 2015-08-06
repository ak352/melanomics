import sys

def get_gene_intersection(data_file, gene_list, out_file):
	# open files
	data = open(data_file, 'r')
	g = open(gene_list, 'r')
	out = open(out_file, 'w')
	          
    	newcontent = 'Sample\tGene\tAlteration\n'
		
	header = data.readline()
	header_fields = header.strip('\n').split('\t') 
	iso_idx = header_fields.index("AAChange.refGene") # get the index for the AAChange index in the data file
	#print iso_idx
	gene_idx = header_fields.index("Gene.refGene") # get the index for the gene index in the data file	
	patient = [s for s in header_fields if s.startswith("patient")][0]
	vartype_idx = header_fields.index("Func.refGene")
	splice_idx = header_fields.index("GeneDetail.refGene")
	
	genes =[]
	for gene in g:
		genes.append(gene.strip())
		
	for line in data:
		line = line.strip("\n").split("\t")
		#print line
		
		## splicing OR exonic
		vartype_inp = line[vartype_idx]
                
		## splicing
		if vartype_inp == "splicing":
                        splice_inp = line[splice_idx]
			splice_list = splice_inp.strip('"').split(",")
                	for splice_nm in splice_list:
                        	print splice_nm
                        	splice = splice_nm.split(":")[0]
                        	print splice
				
				if splice not in genes:
					print splice + " splicing NOT in genes" 
				if splice in genes:
					print splice + " splicing IS in genes"
					splicing_mut = "Sxx_splice"
                        		print splicing_mut	
					gene = line[gene_idx]				
			newline = "\t".join([patient, gene, splicing_mut])
			newcontent +=newline + "\n"
					
		## exonic
		if vartype_inp == "exonic":
			transcript_inp = line[iso_idx]
			#print transcript_inp
			if transcript_inp == "UNKNOWN":
	    			continue
			print transcript_inp
			change_list = transcript_inp.strip('"').split(",")
			#print change_list
			for change in change_list:
				#print change         
				iso = change.split(":")[1]
				print iso
				if iso not in genes:
                			print iso + " iso NOT in genes"
            			if iso in genes:
					print iso + " iso IS in genes"
					protein = change.split(":")[4]
					print protein
					position = protein.split(".")
					#print position
					aa = position[1]
					print aa
					print aa[0]
					print aa[-1]
					if aa[0] == aa[-1]:
                        			print aa + " Not a non-synomymous SNV"
					gene = line[gene_idx]
			newline = "\t".join([patient,gene,aa])  
			newcontent += newline + "\n"

    	# write the new content to the ouptut file
    	out.write(newcontent)
    	# close files
    	data.close()
    	g.close()
	out.close()
			       
if __name__ == '__main__':
    #   python script.py myData.txt gene_intersection.txt
    	data = sys.argv[1] 
    	genes = sys.argv[2]
	out = sys.argv[3]
    	get_gene_intersection(data, genes, out)
