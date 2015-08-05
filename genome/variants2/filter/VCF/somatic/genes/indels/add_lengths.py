import sys
from get_genes import get_longest_gene
from get_genes import get_longest_exome

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
            
if __name__ == "__main__":
    infile = sys.argv[1]

    longest_genes = get_longest_gene()
    longest_cds = get_longest_exome()
    # print(next(open(infile))[:-1] + "\tlongest_length")
    print(next(open(infile))[:-1] + "\tlongest_cds")

    for record in read_tsv(infile):
        hgnc = record['hgnc_symbol']
        # if hgnc not in longest_genes:
        #     sys.stderr.write("[WARN] %s not found in RefSeq\n" % hgnc)
        #     continue
        # print(record['all'] + "\t" + str(longest_genes[hgnc]))


        if hgnc not in longest_cds:
            sys.stderr.write("[WARN] %s not found in RefSeq\n" % hgnc)
        # continue
        print(record['all'] + "\t" + str(longest_cds.get(hgnc,0)))

