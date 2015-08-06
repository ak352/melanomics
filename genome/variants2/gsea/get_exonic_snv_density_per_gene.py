import sys

#Creates a dictionary of fields pointing to column numbers, makes the code more readable
def ParseFields(line):
    fields = {}
    var = line[:-1].split("\t")
    for x in range(0, len(var)):
        fields[var[x]] = x
    return fields

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

def freq_mutated_genes():
    infile = "/work/projects/melanomics/data/commonly_mutated/usually_damaged_genes_UNIQUE"
    return set([line[:-1] for line in open(infile)])



if __name__ == "__main__":
    infile = sys.argv[1]

    with open(infile) as f:
        print(next(f).split("\t")[0] + "\t" + "exonic_snv_density")


    freq_mutated = freq_mutated_genes()
    records = []
    for record in read_tsv(infile):
        if record['hgnc_symbol'] in freq_mutated:
            continue
        if record['longest_cds'] != '0':
            density = float(record['exonic'])*1000000/float(record['longest_cds'])
            records.append(record['hgnc_symbol'] + "\t" + str(density))

    max_density = max([float(x.split("\t")[-1]) for x in records])
    for i,record in enumerate(records):
        record = record.split("\t")
        record[-1] = str(float(record[-1])/max_density)
        records[i] = "\t".join(record)
    
    for k in sorted(records, key=lambda x: float(x.split("\t")[-1]), reverse=True):
        print(k)



