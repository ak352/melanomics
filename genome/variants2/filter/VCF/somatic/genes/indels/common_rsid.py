import sys

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

def read_vcf(infile, count=False):
    with open(infile) as f:
        line = next(f)
        while line.startswith("##"):
            line = next(f)

        assert line.startswith("#CHROM")
        var = ParseFields(line)
        
        num_lines = 0
        for line in f:
            record = {}
            line = line[1:-1].split("\t")
            for x in var:
                record[x] = line[var[x]]
            record["all"] = "\t".join(line)
            num_lines += 1
            if count:
                if num_lines % 1000000:
                    sys.stderr.write("%d lines processed...\n" % num_lines)
            yield record

def read_dbsnp_vcf():
    # common_variants = set()
    # for record in read_vcf(vcf):
    #     for info in record["INFO"].split(";"):
    #         info = info.split("=")
    #         if info[0] == "COMMON":
    #             if info[1] == "1":
    #                 iden = record["ID"]
    #                 assert
    #                 common_variants.add()
    #             values.add(info[1])
    # print values
    return

def report(line, log):
    for s in sys.stderr, log:
        s.write(line)

def get_non_flagged():
    vcf="/work/projects/isbsequencing/data/dbsnp/hg19/dbSNP138/00-All.vcf"
    infile = "/work/projects/melanomics/tools/annovar/2015Mar22/annovar/humandb/hg19_snp138NonFlagged.wheader.txt.rsids"
    stderr = sys.stderr
    stderr.write("dbSNP Non-flagged file: %s\n" % infile)
    
    ids = set([line[:-1] for line in open(infile)])
    return ids


    
    






