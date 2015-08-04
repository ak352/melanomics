import sys
from common_rsid import get_non_flagged

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
            

def report(line, log):
    for s in sys.stderr, log:
        s.write(line)

if __name__ == "__main__":
    infile = sys.argv[1]
    outfile = sys.argv[2]
    logfile = outfile + ".log"
    percent_threshold = 0.01
    out, log = [open(x, "w") for x in [outfile, logfile]]
    annotations = [line[:-1] for line in open("frequency_annotations")]
    non_flagged = get_non_flagged()

    report("Input: %s\n" % infile, log)
    report("Output: %s\n" % outfile, log)
    report("Log file: %s\n" % logfile, log)
    report("Population frequency threshold = %1.2f\n" % percent_threshold, log)

    rare, num_common, total = 0,0,0

    """ Output the header """
    out.write(next(open(infile)))

    count = {}
    for anno in annotations:
        count[anno] = 0
    count["dbsnp"] = 0
    count["avsnp"] = 0

    """ Filter the variants """
    for record in read_tsv(infile):
        is_common = False
        for annotation in annotations:
            if record[annotation]:
                if float(record[annotation]) >= percent_threshold:
                    is_common = True
                    count[annotation] += 1

        if record['snp138'] in non_flagged:
            is_common=True
            count['dbsnp'] += 1
        if record['avsnp138'] in non_flagged:
            is_common=True
            count['avsnp'] += 1
            
            
        total += 1
        if is_common:
            num_common += 1
        else:
            rare += 1
            out.write(record["all"] + "\n")

    report("STATISTICS:\n", log)
    report("Total variants = %d\n" % total, log)
    report("Common variants = %d (%2.2f%%)\n" % (num_common, float(num_common)*100/float(total)), log)
    report("Of which:\n", log)
    for annotation in annotations+['dbsnp', 'avsnp']:
        report("\tVariants found in %s = %d (%2.2f%%)\n" % (annotation, count[annotation], float(count[annotation])*100/float(total)), log)
    report("Rare variants = %d\n" % rare, log)

    


