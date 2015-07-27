#! /usr/bin/python

import sys

def get_input(input_list, out_file):

    # open files
    i = open(input_list, 'r')
    out = open(out_file, 'w')

    #write to new file and add header 
    #newcontent = 'chro\tstart\tstop\tpatient\tvarType\tref\tmut\n'
    #out.write(newcontent)

    header = i.readline()
    # split the header into columns
    header_fields = header.strip('\n').split('\t') 
    # get the gene index from the header
    chr_idx = header_fields.index('chromosome')
    #print chr_idx
    start_idx = header_fields.index('begin')
    stop_idx = header_fields.index('end')
    varType_idx = header_fields.index('varType')
    ref_idx = header_fields.index('reference')
    mut_idx = header_fields.index('alleleSeq')
    func_idx = header_fields.index('Func.refGene')
    patient = [s for s in header_fields if s.startswith('patient')][0]

    out = open(out_file, 'w')

    ##create dict
    ## if somatic 
    #var = {"snp":"substitution"}
    ## if germline
    var = {"snp":"substitution", "ins":"insertion", "del":"deletion", "sub":"substitution"} 

    for line in i:
        line = line.strip('\n').split('\t')
	#if line[func_idx] in ["exonic", "intronic", "intronic;intronic", "ncRNA_exonic", "ncRNA_UTR3", "splicing", "UTR5", "UTR3"] :
	#    continue    
	#if line[func_idx] in ["upstream", "downstream",  
	chro = "chr"+line[chr_idx]
	if chro == "chrMT":
	    continue
	start = line[start_idx]
	stop = line[stop_idx]
	varType = var[line[varType_idx]]
	ref = line[ref_idx]
	#print "ref = ", ref
	if ref == "" :
	    ref = "."
	mut = line[mut_idx]
	if mut == "":
	    mut = "."

	newline = '\t'.join([chro, start, stop, patient, varType, ref, mut]) + '\n' 
    
        #newcontent += newline + '\n'
        
	out.write(newline)
        
    i.close()
    out.close()

if __name__ == '__main__':
    i = sys.argv[1]
    out = sys.argv[2]
    get_input(i, out)
