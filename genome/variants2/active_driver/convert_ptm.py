import sys
import re


def get_genes(gene_file):
    genes = {}
    for gene in gene_file:
        gene = gene.strip('\n').split('\t')
        transcript = gene[0]
        genename = gene[1] 
        genes[transcript] = genename
    return genes

def get_gene_intersection(data_file, gene_list, out_file):
    # open files
    data = open(data_file, 'r')
    g = open(gene_list, 'r')
    out = open(out_file, 'w')
    logfile = out_file + ".log"
    log = open(logfile, "w")
    
    sys.stderr.write("Input: %s\n"% data_file)
    sys.stderr.write("Output: %s\n"% out_file)
    sys.stderr.write("Logfile: %s\n"% logfile)

    genes = get_genes(g)
    
    num_not_found = 0
    out.write(next(data))
    for line in data:
        line = line.strip('\n').split('\t')
        idname = line[0]
        #print line
        #print idname
        if idname not in genes:
            log.write(idname +  " NOT in genes\n")
            num_not_found += 1
        else:
            idname = genes[idname][2:-2]
            line[0] = idname
            line = "\t".join(line)
            out.write(line + "\n")
    sys.stderr.write("Number of transcripts not found in RefSeq = %d\n"% num_not_found)
		            
    # close files
    data.close()
    g.close()
    out.close()


if __name__ == '__main__':
    #   python script.py myData.txt gene_list.txt gene_intersection.txt
    data = sys.argv[1]
    genes = sys.argv[2]
    out = sys.argv[3]
    get_gene_intersection(data, genes, out)

