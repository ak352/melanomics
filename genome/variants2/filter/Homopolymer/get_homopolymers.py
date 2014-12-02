import gzip 
import os
import sys


fasta_file = "/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa" #os.environ['HOME'] + "/resources/refGenomes/hg19.fa"
out = open("hg19_homopolymers", "w+")


out.write(">chromosome\tbegin\tend\tnucleotide\tlength\n")

fasta = open(fasta_file)
loci = 0
char_start = "None"
pos_start = 1
length_homopolymer = 1
chr_start = "1"


print "Reference: ", fasta_file
print "Zero-based, half-open coordinates"

for line in fasta:
    fields = list(line.rstrip("\n"))
    #print fields, loci
    if line.startswith(">"):
        chr = line.lstrip(">").rstrip("\n")
        
            


    else:
        for char in fields:

            #Includes repetitive regions
            if char in ["A", "C", "G", "T", "a", "c", "g", "t"]:
                if char != char_start or chr!=chr_start:
                    
                    #If a new chromosome is read, change current chromosome and reset loci to 0
                    if chr!=chr_start:
                        chr_start = chr
                        loci = 0
                        
                    if char_start != "None":
                        if length_homopolymer > 5:
                            out.write(chr + "\t" + str(pos_start) + "\t" +  str(int(pos_start) + length_homopolymer) + "\t" + char_start + "\t" + str(length_homopolymer) + "\n")
                    pos_start = loci
                    char_start = char
                    length_homopolymer = 1
                    


                else:
                    length_homopolymer = length_homopolymer + 1
                    
            #Increment loci
            loci = loci + 1
                #print pos_start, char_start, loci, char, length_homopolymer
                
