# from pylab import *
import sys


if __name__ == "__main__":
    listfile = "/work/projects/melanomics/analysis/genome/sv/merged/patient_4.INV.list"
    varfile = "/work/projects/melanomics/analysis/genome/lumpy_genome/trim/patient_4.INV.testvariants"
    with open(listfile) as f:
        next(f)
        for lin1 in f:
            lin1 = lin1[:-1].split("\t")
            chrom2 = lin1[0]
            begin2,end2 = [int(x) for x in lin1[1:3]]
            print chrom2, begin2, end2

        
            with open(varfile) as g: 
                next(g)
                for line in g:
                    line = line[:-1].split("\t")
                    chrom2 = line[0]
                    begin2,end2 = [int(x) for x in line[1:3]]
                    print chrom2, begin2, end2
            
        
