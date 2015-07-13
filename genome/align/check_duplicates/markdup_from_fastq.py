from collections import Counter
import sys


""" This could still include adapter sequences """
def collapse(reads1, reads2):
    fragments_w_adapter = []
    count = Counter()
    for k in reads1.keys():
        if k in reads2:
            fragment = reads1[k]+reads2[k]
            fragments_w_adapter.append(reads1[k]+reads2[k])
            count[(":".join(k.split(":")[:4]), fragment)] += 1
    #print count
    num_duplicate_reads = sum([count[f]-1 for f in count])
    print("Number of duplicate reads = %d" % num_duplicate_reads)
    print("Total reads = %d" % sum(count.values()))
    for k in sorted(count, key=lambda x: count[x], reverse=True):
        print count[k], k


def reader(fq):
    reads = {}
    with open(fq) as f:
        while True:
            try:
                line = next(f)[:-1]
                """ Check for BUT or HW in the fagment id as 5 lines/read are not there for some reads """
                if line[:4] == "@BUT" or line[:3]  == "@HW":
                    iden = line.split(" ")[0]
                    seq = next(f)[:-1]
                    #ignore = next(f)[:-1]
                    #qual = next(f)[:-1]
                    assert iden not in reads, iden
                    reads[iden] = seq
            except StopIteration:
                break
    return reads

if __name__ == "__main__":    
    fq1 = sys.argv[1]
    fq2 = sys.argv[2]

    
    reads1 = reader(fq1)
    reads2 = reader(fq2)
    collapse(reads1, reads2)


