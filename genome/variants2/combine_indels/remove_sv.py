import sys
import pysam
import copy 

def usage():
    print "Usage: python remove_sv.py <vcf-file> <reference-genome-fasta>"


if __name__ == "__main__":
    for line in open(sys.argv[1]):
        if line.startswith("#"):
            print line[:-1]
            continue
        line = line[:-1].split("\t")
        alts = line[4].split(",")
        newline = copy.deepcopy(line)
        if "<DEL>" in alts:
            chrom = line[0]
            pos = int(line[1])
            ref = line[3]
            fa = pysam.Fastafile(sys.argv[2])
            prev_ref = fa.fetch(line[0], pos-2, pos-1)
            ref = prev_ref + ref
            pos -= 1
            for x in range(len(alts)):
                if alts[x] == "<DEL>":
                    alts[x] = ""
                alts[x] = prev_ref + alts[x]
            newline[1] = str(pos)
            newline[3] = ref
            newline[4] = ",".join(alts)
            sys.stderr.write("INFO: Line beginning with\n" + "\t".join(line[0:5]) + " corrected to \n" + "\t".join(newline[0:5])+"\n") 
        print "\t".join(newline)

            
            
        
        
    


