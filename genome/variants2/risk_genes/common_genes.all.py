import csv

patients = [2,4,6,7,8]

for p in patients:
    #infiles=["/work/projects/melanomics/analysis/genome/variants2/filter/patient_%d/germline/patient_%d.testvariants.filter.annotated.germline.rare" % (p,p) for p in patients]
    infiles=["/work/projects/melanomics/analysis/genome/variants2/filter/patient_%d/patient_%d.somatic.testvariants.annotated" % (p,p) for p in patients]

all_genes = {}
all_variants = {}
for i,infile in enumerate(infiles):
    genes=set()
    variants = set()
    for row in csv.DictReader(open(infile), delimiter="\t"):
        """ Location of the variant plus the unique variant annotations that should be counted """
        #germline
	#loc = (row['chromosome'], row['begin'], row['end'], row['reference'], row['alleleSeq'], row['snp138'], row['exac02'], row['1000g2012apr_eur'], row['1000g2012apr_all'])
        #somatic
	loc = (row['chromosome'], row['begin'], row['end'], row['reference'], row['alleleSeq'], row['snp138'], row['exac02'], row['1000g2014oct_eur'], row['1000g2014oct_all'])
	#print row.keys()
        for anno in row['AAChange.refGene'].split(","):
            if not anno:
                continue
            if anno == 'UNKNOWN':
                continue
                
            #print anno
            anno = anno.split(":")
            g = anno[0]
            transcript = anno[1]
            if len(anno) > 4:
                aa_change = row['AAChange.refGene'].split(":")[4]
            else:
                aa_change = "None"
            #sift = row['LJB23_SIFT_pred']
            #pp = row['LJB23_Polyphen2_HDIV_pred']
            variants.add((loc, g, transcript, aa_change)) #, sift, pp))
            
        genes.add(row['Gene.refGene'])

        #print row.keys()

    for gene in genes:
        if gene not in all_genes:
            all_genes[gene] = []
        all_genes[gene].append(patients[i])

    for variant in variants:
        if variant not in all_variants:
            all_variants[variant] = []
        all_variants[variant].append(patients[i])


for variant in reversed(sorted(all_variants, key= lambda x: len(all_variants[x]))):
    print variant, all_variants[variant]
        
for gene in reversed(sorted(all_genes, key= lambda x: len(all_genes[x]))):
    print gene, all_genes[gene]
    



        
