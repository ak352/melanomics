import sys
import re

def indel2GT(g1, g2, ref, alt):
    zygosities = [[0,0],[0,0]]
    genotypes = [g1,g2]
    for k in range(2):
        if genotypes[k]=="hom":
            zygosities[k] = [1,1]
        elif genotypes[k]=="het":
            zygosities[k] = [0,1]
    return ["/".join([str(k) for k in sorted(zygosity)]) for zygosity in  zygosities]
    


def genotype2GT(g1, g2, ref, alt):
    assert len(g1)==len(g2)
    assert len(g1)==2
    assert g1[0] == g1[1]
    alt = alt.split(",")
    # index = 0
    # indices = {}
    # zygosity = []
    # for k in range(2):
    #     if g1[k] == g2[k]:
    #         zygosity.append(0)
    #     else:
    #         if g2[k] not in indices:
    #             index += 1
    #             indices[g2[k]] = index
    #         zygosity.append(indices[g2[k]])
    zygosities = [[0,0],[0,0]]
    genotypes = [g1,g2]
    for k in range(2):
        for n in range(2):
            if genotypes[k][n]==ref:
                zygosities[k][n] = 0
            else:
                for m in range(len(alt)):
                    #print genotypes[k][n], alt[m], genotypes[k][n] == alt[m]
                    if genotypes[k][n] == alt[m]:
                        zygosities[k][n] = m+1

        
    # for zygosity in zygosities:
    #     print "/".join([str(k) for k in sorted(zygosity)])
    return ["/".join([str(k) for k in sorted(zygosity)]) for zygosity in  zygosities]


if __name__=="__main__":
    inputs = open("input", "r")
    num_input = int(inputs.readline()[:-1])
    for k in range(num_input):
        infile=inputs.readline()[:-1]
        outfile_name = inputs.readline()[:-1]
        variant_type = inputs.readline()[:-1]
        if variant_type == "snp":
            sys.stderr.write("[INFO] Variant type = snp\n")
        elif variant_type == "indel":
            sys.stderr.write("[INFO] Variant type = indel\n")
        else:
            sys.stderr.write("[WARNING] Variant type must be snp or indel\n") 
            continue
        outfile = open(outfile_name, "w+")
        sys.stderr.write("[INFO] Input: %s\n" % (infile))
        sys.stderr.write("[INFO] Output: %s\n" % (outfile_name))

        f = open(infile)
        line = next(f)
        while line.startswith("##"):
            outfile.write(line)
            line = next(f)
        outfile.write('##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">\n')
        outfile.write(line)    
        for line in f:
            line = line[:-1].split("\t")
            [ref, alt] = line[3:5]
            info = line[7].split(";")
            info = dict([inf.split('=') for inf in info if'=' in inf ])
            sgt = info['SGT']
            if variant_type == "snp":
                zygosities = genotype2GT(sgt[0], sgt[1], ref, alt)
            elif variant_type == "indel":
                try:
                    zygosities = indel2GT(sgt[0], sgt[1], ref, alt)
                except IndexError:
                    print line[7], sgt
            line[8] = "GT:"+ line[8]
            line[9] = zygosities[0] +":"+ line[9]
            line[10] = zygosities[1] +":"+ line[10]
            outfile.write("\t".join(line)+"\n")




