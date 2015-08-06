import numpy as np
import sys

infile = "/work/projects/melanomics/tools/annovar/2014Nov12/humandb/hg19_refGene.wheader.txt"
chromosomes = [str(x) for x in range(1,23)]
chromosomes.extend(["X", "Y", "MT"])

#chromosomes = ["chr"+x for x in chromosomes]



with open(infile) as f:
    next(f)
    for line in f:
        line = line[:-1].split("\t")
        chrom = line[2] 
        cdsStart, cdsEnd = [int(x) for x in [line[6], line[7]]]
        exonStarts, exonEnds = line[9], line[10]
        if chrom not in chromosomes:
            continue
        #print chrom, cdsStart, cdsEnd, exonStarts, exonEnds

        exonStarts = np.array([int(x) for x in exonStarts.split(",")[:-1]])
        exonEnds = np.array([int(x) for x in exonEnds.split(",")[:-1]])
        num_exons = len(exonStarts)

        
        start_idx = (exonStarts >= cdsStart) & (exonStarts <= cdsEnd)
        end_idx = (exonEnds >= cdsStart) & (exonEnds <= cdsEnd)
        

        # If CDS->(start,end) = (4,10), then exons (2-5,8-11) will be reduced to (4-5,8-10)
        # as start_idx = [0,1] and end_idx = [1,0] and start_idx & end_idx = [0,0]
        # So, if start_idx XOR end_id
        #print start_idx, end_idx, start_idx ^ end_idx

        for i,idx in enumerate(start_idx):
            if not idx and end_idx[i]:
                exonStarts[i] = cdsStart
        for i,idx in enumerate(end_idx):
            if not idx and start_idx[i]:
                exonEnds[i] = cdsEnd
                
        #print exonStarts[idx], exonEnds[idx]
        exonStarts = exonStarts[start_idx | end_idx] # & end_idx]
        exonEnds = exonEnds[start_idx | end_idx]
        sys.stderr.write("%d exons removed from CDS\n" % (num_exons - np.sum(start_idx | end_idx)))

        for i,exonStart in enumerate(exonStarts):
            sys.stdout.write("%s\t%d\t%d\n" % (chrom, exonStart, exonEnds[i]))
            

        
                                           
    
        
        
