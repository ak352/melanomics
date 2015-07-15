import sys

# Translation from ANNOVAR to MAF
d = {'intronic':'Intron',
     'UTR5': "5'UTR",
     'UTR3': "3'UTR",
     'upstream':"5'Flank",
     'downstream':"3'Flank",
     'intergenic': 'IGR',
     'synonymous SNV': 'Silent',
     'nonsynonymous SNV': 'Missense_Mutation',
     'stopgain': 'Nonsense_Mutation',
     'stoploss': 'Nonstop_Mutation',
     'ncRNA_exonic': 'RNA',
     'ncRNA_intronic': 'RNA',
     'unknown': 'Silent'
     }


#Creates a dictionary of fields pointing to column numbers, makes the code more readable
def ParseFields(line):
    fields = {}
    var = line[:-1].split("\t")
    for x in range(0, len(var)):
        fields[var[x]] = x
    return fields

def header(infile):
    with open(infile) as f:
        return next(f)[:-1].split("\t")


def read_tsv(infile):
    with open(infile) as f:
        var = ParseFields(next(f))
        
        for line in f:
            record = {}
            line = line[:-1].split("\t")
            for x in var:
                record[x] = line[var[x]]
            record["all"] = "\t".join(line)
            yield record
            

def report(line, log):
    for s in sys.stderr, log:
        s.write(line)

def get_alleles(ref, alt, genotype):
    assert genotype in ["01", "11"], ("genotype = ", genotype)
    if genotype == "01":
        return (ref,alt)
    elif genotype == "11":
        return (alt,alt)
        
def get_variant_class(func, exonic_func):
    # Variant_Classification is not {Intron, 5'UTR, 3'UTR, 5'Flank, 3'Flank, IGR}, 
    # which implies that Variant_Classification can only be \{Frame_Shift_Del, 
    # Frame_Shift_Ins, In_Frame_Del, In_Frame_Ins, Missense_Mutation, 
    # Nonsense_Mutation, Silent, Splice_Site, Translation_Start_Site, 
    # Nonstop_Mutation, RNA, Targeted_Region}. 
    
    # For our case, it can only be Intron, 5'UTR, 3'UTR, 5'Flank, 3'Flank, IGR,
    # Missense_Mutation, Nonsense_Mutation, Silent, Splice_Site, Translation_Start_Site, 
    # Nonstop_Mutation
    is_splicing = False
    if "splicing" in func:
        is_splicing = True

    if func in d:
        return d[func]
    elif exonic_func in d:
        return d[exonic_func]
    elif is_splicing:
        return "Splice_Site"
    else:
        return None


def process_exonic_func(func, exonic_func, alleles, record, genes):
    mut_class = get_variant_class(func, exonic_func)
    if "," in record["Gene.refGene"]:
        if func not in  ["intergenic", "UTR5", "UTR3", "upstream", "downstream", "intronic", "exonic", "ncRNA_intronic", "ncRNA_exonic", "splicing"]:
            print func
            print record["all"]
            sys.exit()
    for gene in genes.split(","):
        # Note: Convert to 1-based indexing; all variants are SNVs - so begin += 1
        newline = [gene,
                   "37",
                   record["chromosome"],
                   str(int(record["begin"])+1),
                   record["end"],
                   "+",
                   mut_class,
                   record["reference"],
                   alleles[0],
                   alleles[1],
                   patient,
                   record["snp138"]
                   ]
        try:
            print("\t".join(newline))
        except TypeError:
            print(record["all"])
            sys.exit()


def process_func(func, record, genes):
        # if "splicing"!=func and record["ExonicFunc.refGene"] not in d and func not in ["intergenic", "UTR5", "UTR3", "upstream", "downstream"]:
        #     continue

        alleles = get_alleles(record["reference"], record["alleleSeq"], record[patient])
        
        for exonic_func in record["ExonicFunc.refGene"].split(";"):
            process_exonic_func(func, exonic_func, alleles, record, genes)


    
def print_maf(patient, infile):
    for record in read_tsv(infile):
        """ Assumes all exonic function annotation field have only 1 annotation; no combined ones """
        #TODO: Should we include UTR, upstream, downstream, IGR etc.? What would be the gene field then?
        """ There should be the same number of ;-delimited fields in Gene.refGene and in Func.refGene """
        genes = record["Gene.refGene"].split(";")
        for i,func in enumerate(record["Func.refGene"].split(";")):
            process_func(func, record, genes[i])


# print(header(infile))

nheader = ["Hugo_Symbol",
           "NCBI_Build",
           "Chromosome",
           "Start_position",
           "End_position",
           "Strand",
           "Variant_Classification",
           "Reference_Allele",
           "Tumor_Seq_Allele1",
           "Tumor_Seq_Allele2",
           "Tumor_Sample_Barcode",
           "dbSNP_RS"
           ]
print("\t".join(nheader))

patients = ["patient_%d" % p for p in [2,4,6,7,8]]
for patient in patients:
    infile="/work/projects/melanomics/analysis/genome/variants2/filter/%s/somatic/%s.somatic.testvariants.annotated.rare" % (patient, patient)
    #print("\n".join(header(infile)))
    print_maf(patient, infile)



# Hugo_Symbol
# Entrez_Gene_Id
# Center
# NCBI_Build
# Chromosome
# Start_position
# End_position
# Strand
# Variant_Classification
# Variant_Type
# Reference_Allele
# Tumor_Seq_Allele1
# Tumor_Seq_Allele2
# dbSNP_RS
# dbSNP_Val_Status
# Tumor_Sample_Barcode
# Matched_Norm_Sample_Barcode
# Match_Norm_Seq_Allele1
# Match_Norm_Seq_Allele2
# Tumor_Validation_Allele1
# Tumor_Validation_Allele2
# Match_Norm_Validation_Allele1
# Match_Norm_Validation_Allele2
# Verification_Status
# Validation_Status
# Mutation_Status
# Sequencing_Phase
# Sequence_Source
# Validation_Method
# Score
# BAM_file
# Sequencer
# Genome_Change
# Annotation_Transcript
# Transcript_Strand
# Transcript_Exon
# Transcript_Position
# cDNA_Change
# Codon_Change
# Protein_Change
# is_coding
# is_silent
# categ



