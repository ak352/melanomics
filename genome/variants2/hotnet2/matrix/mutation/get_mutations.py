import csv


def mutate_genes(sample, infile, out, usually_mutated_genes):
    print("Input: %s" % infile)
    mutated_genes = set()
    with open(infile) as f:
        csvreader = csv.DictReader(f, delimiter="\t")
        for record in csvreader:
            funcs = record['Func.refGene'].split(";")
            gene_sets = record['Gene.refGene'] .split(";")
            exonic_func = record['ExonicFunc.refGene']
            for i,x in enumerate(funcs):
                #if x in ["splicing", "exonic", "intronic", "UTR3", "UTR5"]:
                if x in ["splicing", "exonic"]:
                    """ Only amino-acid changing SNV """
                    if x=="splicing" or exonic_func not in ["", "NONE", "synonymous SNV"]:
                        #print exonic_func
                        genes = set(gene_sets[i].split(","))
                        mutated_genes |= genes

    """ Filter the frequently mutated genes """                    
    mutated_genes -= usually_mutated_genes
    print("\t".join([sample] + [str(len(mutated_genes))]))                
    out.write("\t".join([sample] + sorted(list(mutated_genes)))+"\n")



    
if __name__ == "__main__":
    outfile = "/work/projects/melanomics/analysis/genome/variants2/hotnet/mutations/snv.blacklist_filt"
    usually_mutated_file = "/work/projects/melanomics/data/commonly_mutated/usually_damaged_genes_UNIQUE"
    usually_mutated_genes = set(line.strip() for line in open(usually_mutated_file))
    out = open(outfile, "w")
    print("Output: %s" % outfile)
    
    samples = [2,4,6,7,8]
    infiles = ["/work/projects/melanomics/analysis/genome/variants2/filter/patient_%d/somatic/patient_%d.somatic.testvariants.annotated.rare.aachanging" % (s,s) for s in samples]
    for i,infile in enumerate(infiles):
        mutate_genes("patient_%d" % samples[i], infile, out, usually_mutated_genes)










    
