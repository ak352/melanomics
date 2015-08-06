#! /usr/bin/python

import sys
import re

#Creates a dictionary of fields pointing to column numbers, makes the code more readable
def ParseFields(line):
    fields = {}
    var = line.rstrip("\n").lstrip("#").lstrip(">").split("\t")
    for x in range(0, len(var)):
        fields[var[x]] = x
    return fields

def get_active_driver_transcript(fname):
	n = open(fname, "r")
	nms = []
	for nm in n:
		nms.append(nm.strip())    
	
	n.close()
	return nms


def get_longest_transcript(fname):
	n = open(fname, "r")
	var = ParseFields(next(n))
	nms = []
	for nm in n:
		nms.append(nm[:-1].split("\t")[var["refseq_longest"]])    
	
	n.close()
	return nms

def report_io(data_file, out_file, logfile, log):
        sys.stderr.write("Input: %s\n"% data_file)
        sys.stderr.write("Output: %s\n"% out_file)
        sys.stderr.write("Logfile: %s\n"% logfile)
        log.write("Input: %s\n"% data_file)
        log.write("Output: %s\n"% out_file)
        log.write("Logfile: %s\n"% logfile)


def get_mutationMapper_input(data_file, nm_list, out_file, logfile):
	# open files
	data = open(data_file, 'r')
	#nms = get_active_driver_transcript(nm_list)
	nms = get_longest_transcript(nm_list)
        log = open(logfile, "w")
	out = open(out_file, 'w')
        
        report_io(data_file, out_file, logfile, log)

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
	

	for line in data:
		line = line.strip('\n').split('\t')
		
		### splicing OR exonic
                vartype_inp = line[vartype_idx]
		
		## splicing
                #if vartype_inp == "splicing":
		#PROBLEM TO GET AA for splice sites!!! TO DO!!
		
		## exonic
		if vartype_inp == "exonic":
			
			## NMids form genes of interest
			transcript_inp = line[iso_idx]
			if not transcript_inp or transcript_inp == "UNKNOWN":
				continue
			change_list = transcript_inp.strip('"').split(',')	
			for change in change_list:
          	 		nm_inp = change.split(":")[1]		
				if nm_inp not in nms:
                                    log.write("%s is NOT in nms\n" % nm_inp)
                                    #print nm_inp + " is NOT in nms"
				if nm_inp in nms:
                                    log.write("%s is in nms\n" % nm_inp)
                                    #print nm_inp + " is in nms"
                                    protein_inp = change.split(':')[4]
                                    #print protein_inp
                                    if not protein_inp or protein_inp == "":
                                        log.write("%s No AA change\n" % protein_inp)
                                        #print protein_inp + " No AA change"
                                    protein = protein_inp.split(".")
                                    print protein
                                    aa = protein[1]
                                    print aa
                                    print aa[0]
                                    print aa[-1]
                                    if aa[0] == aa[-1]:
                                        log.write("%s Not in non-synonymous SNV\n" % aa)
                                        print aa + " Not a non-synomymous SNV"
                                    chromosome = line[chromosome_idx]
                                    start = line[start_idx]
                                    end = line[end_idx]
                                    gene = line[gene_idx]
                                    variant = line[variant_idx]
                                    newline = "\t".join([gene, patient, aa, variant, chromosome, start, end])
                                    newcontent += newline + "\n"

	# open a new file object for writing
	out = open(out_file, 'w')
	# write the new content to the ouptut file
	out.write(newcontent)

	# close files
	data.close()
	out.close()
        log.close()

if __name__ == '__main__':
	#   python script.py myData.txt gene_list.txt output.txt
	data = sys.argv[1]
	nms = sys.argv[2]
	out = sys.argv[3]
        logfile = sys.argv[3] + ".log"
	get_mutationMapper_input(data, nms, out, logfile)
