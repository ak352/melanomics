from pylab import *
from collections import Counter

def parse_fields(header):
    var = {}
    for i,k in enumerate(header[:-1].split("\t")):
        var[k] = i
    return var

def read_tsv(infile):
    with open(infile) as f:
        var = parse_fields(next(f))
        for line in f:
            record = {}
            record['all'] = line[:-1]
            line = line[:-1].split("\t")
            for k in var:
                record[k] = line[var[k]]
            yield record
            
def get_thresh():
    threshs = []
    for line in open("threshold"):
        line = line.rstrip("\n").split("\t")
        threshs.append((int(line[0]), int(line[1]), line[2]))
    return threshs

def get_new_status(abs_diff, threshs):
    anno = []
    for thresh in threshs:
        if abs_diff >= thresh[0] and abs_diff <= thresh[1]:
            anno.append(thresh[2])
    anno = ",".join(anno)
    return anno

if __name__ == "__main__":

    infile="/work/projects/melanomics/analysis/genome/activeDriver/results/missense_all/patient8_merged_report.TEST.txt"


    threshs = get_thresh()
    labels = [x[2] for x in threshs]
    counts = Counter()
    for record in read_tsv(infile):
        abs_diff = abs(int(record['mut_position']) - int(record['PTM_position']))
        status = record['status']

        new_status = get_new_status(abs_diff, threshs)
        counts[new_status] += 1
        #line = "\t".join(record['all'].split("\t")+[new_status])
    bar(range(len(labels)), [counts[label] for label in labels])
    xticks(arange(0.2,len(labels))+0.2, labels)
    ylabel('Number of phosphosites')
    savefig('counts.png')
    savefig('counts.pdf')
    show()
