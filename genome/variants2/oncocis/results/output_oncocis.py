#! /usr/bin/python

import sys

def get_input(input_list, out_file):

    # open files
    i = open(input_list, 'r')
    out = open(out_file, 'w')
    
    header = i.readline()
    # split the header into columns
    header_fields = header.strip('\n').split('\t')
    chr_idx = header_fields.index('Chrom')
    start_idx = header_fields.index('Start')
    stop_idx = header_fields.index('End')
    varType_idx = header_fields.index('Base')
    pat_idx = header_fields.index('SampleID')
    gene_idx = header_fields.index('Gene')
    drug_idx = header_fields.index('Druggable')
    distTSS = header_fields.index('DistanceToTSS') 
    dhs_idx = header_fields.index('DHS')
    h3k4me1_idx = header_fields.index('DHS')
    h3k4me3 = header_fields.index('H3K4me3')
    h3k27ac = header_fields.index('H3K27ac')
    consMut_idx = header_fields.index('Conservation_at_mutation')
    consBack = header_fields.index('BackgroundConservation')
    create = header_fields.index('Motifs_Created')
    remove = header_fields.index('Motifs_removed')
    fanProm = header_fields.index('Fantom5_Promoter')
    fanEnh = header_fields.index('Fantom5_Enhancer')

    out.write(header)

    for line in i:
	line = line.strip('\n').split('\t')
	#print line
	nums = map(int, line[dhs_idx:h3k27ac+1])
	
	## filtering non-zero entries
	if any(nums)  and (line[create]!="-" or line[remove] != "-") :
#	    print line
	
	    newline = '\t'.join(line) + '\n'
	    #newline = '\t'.join([chr_idx, start_idx, stop_idx, varType_idx, pat_idx, gene_idx, drug_idx, distTSS, dhs_idx, h3k4me1_idx, h3k4me3, h3k27ac, consMut_idx, consBack, create, remove, fanProm, fanEnh]) + '\n'	

	    out.write(newline)

    i.close()
    out.close()

if __name__ == '__main__':
    i = sys.argv[1]
    out = sys.argv[2]
    get_input(i, out)
