from collections import defaultdict
import sys
import json

copy_effect = defaultdict(list)

samples = [2,4,6,7,8]

infiles = ["/work/projects/melanomics/analysis/genome/abscnseq/vs2_min1000/P%d.vs2.wheader.dgv.genes.affected_genes" % s for s in samples]
outfile = "/work/projects/melanomics/analysis/genome/variants2/hotnet/mutations/cnv"
usually_mutated_file = "/work/projects/melanomics/data/commonly_mutated/usually_damaged_genes_UNIQUE"
usually_mutated_genes = set(line.strip() for line in open(usually_mutated_file))
out = open(outfile, 'w')
patients = ["patient_%d" % s for s in samples]

for i,patient in enumerate(patients):
    genes = json.loads(open(infiles[i]).read())

    genes['gain'] = list(sorted(set(genes['gain'])-usually_mutated_genes))
    genes['loss'] = list(sorted(set(genes['loss'])-usually_mutated_genes))
    
    out.write("\t".join([patient] + [g+"(A)" for g in genes['gain']] + [g+"(D)" for g in genes['loss']]) + "\n")
    print set(genes['gain']) & set(genes['loss'])
    
