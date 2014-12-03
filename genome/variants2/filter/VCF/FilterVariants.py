#Creates a dictionary of fields pointing to column numbers, makes the code more readable                                                                              
def ParseFields(line):
    fields = {}
    var = line.rstrip("\n").lstrip("#").lstrip(">").split("\t")
    for x in range(0, len(var)):
        fields[var[x]] = x
    return fields

#Strips any leading ">" or "#" and lagging "\n", a very common operation for master files                                                                             
def StripLeadLag(line):
    var = line.rstrip("\n").lstrip("#").lstrip(">").split("\t")
    return var



file = open("../SelfChainedRegions/sc.out")
out = open("filtered_testvariants", "w+")
rejected = open("rejected", "w+")
sample_names = ["GS00533-DNA_A01_201_37-ASM", "SS6002862"]
coverage = [("coverage_", 20.0, 100.0), ("coverage_SS6002862", 20.0, 70.0)]
variant_scores = [("alleleVarScoreVAF_GS00533-DNA_A01_201_37-ASM", 60.0), ("Q(variant)_SS6002862", 100.0)]
indel_distance_threshold = 5

num_filtered = 0


for line in file:
    reasons = []

    filter = False

    var = StripLeadLag(line)
    if line.startswith(">"):
        fields = ParseFields(line)
        out.write("\t".join(var[0:8+len(sample_names)]) + "\n")

        rejected.write("\t".join(var[0:8+len(sample_names)]))
        rejected.write("\t" + "reason\n")

    else:
        #Filter 1 - Uncertain calls
        for x in sample_names:
            if "N" in var[fields[x]]:
                filter=True
                #reasons.append(x+"="+var[fields[x]])
                reasons.append(var[fields[x]])

        #Filter 2 - Variant scores
        for x in variant_scores:
            if var[fields[x[0]]]!="":
                if float(var[fields[x[0]]]) < float(x[1]):
                    filter=True
                    #reasons.append(x[0]+"="+var[fields[x[0]]])
                    reasons.append(x[0])

        #Filter 3 - Coverage or read-depth
        for x in coverage:
            if float(var[fields[x[0]]]) < float(x[1]) or float(var[fields[x[0]]]) > float(x[2]):
                filter=True
                #reasons.append(x[0]+"="+var[fields[x[0]]])
                reasons.append(x[0])
    
        #Filter 4 - Near an indel (filter if indel within 5 bases)
        if var[fields["varType"]]=="snp":
            assert var[fields["NearestIndelDistance"]]!="", line
            if int(var[fields["NearestIndelDistance"]]) < indel_distance_threshold:
                filter=True
                #reasons.append("NearestIndelDistance="+var[fields["NearestIndelDistance"]])
                reasons.append("NearestIndelDistance")

        



        #Other filters - simple repeat, microsatellites, segmental duplication, repeat masker, self-chained regions, homopolymer runs, distance to homopolymer runs
        #other_filters = []
        other_filters=["Homopolymer", "simple repeat", "segmental duplication", "repeat masker", "microsatellites", "self-chained regions"]
        for f in other_filters:
            if var[fields[f]]!="":
                filter=True
                reasons.append(f)

        




        if filter==False:
            #out.write(line)
            out.write("\t".join(var[0:8+len(sample_names)]))
            #out.write("\t")
            #out.write(";".join(reasons))
            out.write("\n")
            

        rejected.write("\t".join(var[0:8+len(sample_names)]))
        rejected.write("\t" + ";".join(reasons))
        rejected.write("\n")

        if filter==True:
            num_filtered = num_filtered + 1



#Summary
print num_filtered, " variants filtered."
