import os
import sys

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



file = open("nearest_indel")
out = open("nearest_indel_distance", "w+")
for line in file:
    var = StripLeadLag(line)
    if line.startswith(">"):
        fields = ParseFields(line)
        out.write("\t".join(var[:-4]) + "\tNearestIndelDistance\n")

    else:
        line = "\t".join(var[:-4]) + "\t"
        if int(var[fields["DistanceBefore"]]) <= int(var[fields["DistanceAfter"]]):
            line = line + var[fields["DistanceBefore"]]
        else:
            line = line + var[fields["DistanceAfter"]]
        line = line + "\n"
        out.write(line)


