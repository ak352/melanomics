import sys
import fileinput 

def has_dgv(string):
    strings = string.split(";")
    for s in strings:
        s = s.split(":")
        if s[0]=="y" and int(s[1])>50:
            return True
    return False



num_genes_no_annotation = set()
total = set()
genes_with_novel_cnv = set()

f = fileinput.input()

line = next(f)
for line in f:
    line = line[:-1].split("\t")
    gene = line[0]
    dgv = line[2]

    if not line[1]:
        num_genes_no_annotation.add(gene)
        continue

    ratios = line[1].split(";")

    if not has_dgv(dgv):
        genes_with_novel_cnv.add(gene)
        #print "\t".join(line)
    total.add(gene)

print("Genes with novel CNVs (< 50%% overlap with DGV variants) = %d" % len(genes_with_novel_cnv))
print("Total number of genes = %d" % len(total))
#print("Genes with no overlap with any CNV segment = %d" % len(num_genes_no_annotation))
#print("Genes: %s" % ",".join(sorted(genes_with_novel_cnv))) 
 
        
