import sys
from pylab import *

#Creates a dictionary of fields pointing to column numbers, makes the code more readable                                                                                                                                             
def ParseFields(line):
    fields = {}
    var = line.rstrip("\n").lstrip("#").lstrip(">").split("\t")
    for x in range(0, len(var)):
        fields[var[x]] = x
    return fields

#Strips any leading ">" or "#" and lagging "\n", a very common operation for master files                                                                                                                                             
def Strip(line):
    var = line.rstrip("\n").lstrip("#").lstrip(">").split("\t")
    return var

def savestats(covs, label, output):
    out = open(output, "w+")
    for i,cov in enumerate(covs):
        out.write("%s = %s\n" % (label[i], str(len(cov))))
    out.close()

def savehist(data, label, output):
    x,a = data
    out = open("%s.%s.hist" % (output, label), "w+")
    for i,k in enumerate(x):
        out.write("%s\t%s\n" % (str(a[i]), str(x[i])))
    out.close()
        
def usage():
    x = "python %s <normal-label> <tumor-label> <output-prefix> <attribute> <variant-type>\n" % sys.argv[0]
    sys.stderr.write(x)
    sys.exit()




if __name__== "__main__":
    normal = sys.argv[1]
    tumor = sys.argv[2]
    output = sys.argv[3]
    attribute = sys.argv[4] # coverage or quality
    if len(sys.argv) > 5:
        vartype = sys.argv[5]
        if vartype not in ["snp", "indelsub", "all"]:
            sys.stderr.write("variant-type must be one of snp, indelsub or all\n")
            usage()
    else:
        vartype = "all"

    if attribute not in ["NearestHpDistance"]:
        usage()
    if attribute == "NearestHpDistance":
        max_threshold = 100
        
    infile="/work/projects/melanomics/analysis/genome/variants2/filter/hp_ms_rm_sr_sd/all.hp_ms_rm_sr_sd.out"
    k = 0
    concordant_normal = []
    concordant_tumor = []
    discordant_normal = []
    discordant_tumor = []
    partial_normal = []
    partial_tumor = []

    for line in open(infile):
        k += 1
        if line[0] in ">v#":
            fields = ParseFields(line)
            continue
        line = Strip(line)
        if vartype != "all":
            if vartype == "snp" and line[fields["varType"]] != "snp":
                continue
            if vartype == "indelsub" and line[fields["varType"]] not in ["ins", "del", "sub"]:
                continue
        if "1" in line[fields[normal]] or "1" in line[fields[tumor]]:
            coverage_normal = float(line[fields[attribute]])
            coverage_tumor = float(line[fields[attribute]])

            if line[fields[normal]]==line[fields[tumor]]:
                concordant_normal.append(coverage_normal)
                concordant_tumor.append(coverage_tumor)
            elif ("1" in line[fields[normal]] and line[fields[tumor]]=="00") or \
                    ("1" in line[fields[tumor]] and line[fields[normal]]=="00"):
                discordant_normal.append(coverage_normal)
                discordant_tumor.append(coverage_tumor)
            else:
                partial_normal.append(coverage_normal)
                partial_tumor.append(coverage_normal)

    
    concordant_normal = [x for x in concordant_normal if x <max_threshold]
    discordant_normal = [x for x in discordant_normal if x <max_threshold]
    concordant_tumor = [x for x in concordant_tumor if x <max_threshold]
    discordant_tumor = [x for x in discordant_tumor if x <max_threshold]
    covs = [concordant_normal, discordant_normal, concordant_tumor, discordant_tumor]
    labels = ["concordant_normal", "discordant_normal", "concordant_tumor", "discordant_tumor"]
    
    prefix=""
    if vartype != "all":
        prefix = vartype+"."
    savestats(covs, labels, "%s.%s%s.txt" % (output, prefix, attribute))

    data = [[x, y] for x,y in zip(covs, labels)]
    for i,point in enumerate(data):
        [x, a] = histogram(point[0], bins=range(max_threshold), normed=True)
        savehist((x, a), point[1], "%s.%s%s" % (output, prefix, attribute))

    
        
    

