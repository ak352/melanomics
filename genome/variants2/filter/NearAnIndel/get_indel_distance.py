import os
import sys


#Create a directory for intermediate files
if not os.path.isdir("output"):
    os.makedirs("output")

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

sample = sys.argv[1]
out = open("output/nearest_indel_before", "w+")
#file = open("../master.GS00533.GS00003432.SS6002862.tested.illumina")
#file = open("../VariantScore/vs.out")
file = open("id.out")


current = []


for line in file:
    var = StripLeadLag(line)
    if line.startswith(">"):
        fields = ParseFields(line)
        out.write(line.rstrip("\n")+"\tvariantIdNearest_%s\tDistanceBefore_%s\n" % (sample,sample))
    else:
        if var[fields["varType"]] in ["ins", "del", "sub"] and "1" in var[fields[sample]]:
            current = var

        #Print indels and subs
        if var[fields["varType"]]!="snp":
            out.write(line)
        

        if var[fields["varType"]]=="snp" and "1" in var[fields[sample]]:
            #If no indel encountered yet, set distance = -1, and move on to the next variant                                                                                      
            if current == []:
                var.append("-1")
                var.append("-1")
                out.write("\t".join(var)+"\n")
                continue

            if var[fields["chromosome"]]==current[fields["chromosome"]]:
                var.append(current[fields["variantId"]])
                distance = int(var[fields["begin"]])-int(current[fields["end"]])
                #Since the list is sorted by position, distance=-1 could only happen when there is a snp followed by an insertion (so ins_begin - snp_end = -1)
                #In this case, let distance = 0
                if distance==-1:
                    distance=0
                
                var.append(str(distance))

            else:
                var.append("-1")
                var.append("-1")
            out.write("\t".join(var)+"\n")
        elif var[fields["varType"]]=="snp":
            out.write(line)

        
file.close()
out.close()

#Reverse the order of the variants
os.system("python reverse_file.py output/nearest_indel_before output/nearest_indel_before.reversed")

out = open("output/nearest_indel.reversed.annotated", "w+")
file = open("output/nearest_indel_before.reversed")

current = []

for line in file:
    var = StripLeadLag(line)
    if line.startswith(">"):
        fields = ParseFields(line)
        out.write(line.rstrip("\n")+"\tvariantIdNearestAfter_%s\tDistanceAfter_%s\n" % (sample, sample))
    else:
        if (var[fields["varType"]]=="ins" or var[fields["varType"]]=="del") and "1" in var[fields[sample]]:
            current = var
        
        #Print indels and subs
        if var[fields["varType"]]!="snp":
            out.write(line)


        if var[fields["varType"]]=="snp" and "1" in var[fields[sample]]:

            #If no indel encountered yet, set distance = -1, and move on to the next variant                                                                                     
            if current == []:
                var.append("-1")
                var.append("-1")
                out.write("\t".join(var)+"\n")
                continue

            #If indel encountered, label the distance to that indel
            if var[fields["chromosome"]]==current[fields["chromosome"]]:
                var.append(current[fields["variantId"]])

                distance = int(current[fields["begin"]]) - int(var[fields["end"]])
                #Since the list is sorted by position, distance=-1 could only happen when there is a snp followed by an insertion (so ins_begin - snp_end = -1)
                #In this case, let distance = 0                                                                                                                        
                if distance==-1:
                    distance=0

                var.append(str(distance))


            else:
                #-1 signifies that there is no indel in this direction in the same chromosome
                var.append("-1")
                var.append("-1")
            out.write("\t".join(var)+"\n")                                                                                                                       
        elif var[fields["varType"]]=="snp":
            out.write(line)

file.close()
out.close()
#Reverse the order of the variants to get the original order
os.system("python reverse_file.py output/nearest_indel.reversed.annotated output/nearest_indel")       
               

#Choose the indel before or the indel after snp as the nearest indel
file = open("output/nearest_indel")
out = open("output/nearest_indel_distance", "w+")
for line in file:
    var = StripLeadLag(line)
    if line.startswith(">"):
        fields = ParseFields(line)
        out.write(">" + "\t".join(var[:-4] )+ "\tNearestIndelDistance_%s\n" % sample)

    else:

        #Just print the indels and subs as they are
        if var[fields["varType"]]!="snp":
            out.write(line.rstrip("\n") + "\t\n")

        if var[fields["varType"]]=="snp":
            if "1" not in var[fields[sample]]:
                out.write(line.rstrip("\n") + "\t\n")
                continue

            line = "\t".join(var[:-4]) + "\t"
            #assert (int(var[fields["DistanceBefore_%s" % sample]])!=-1 or int(var[fields["DistanceAfter_%s" % sample]])!=-1), "No homopolymer region in chromosome"

            #If there are indels before and after the variant, compare the distances                                                                                                                                         
            if int(var[fields["DistanceBefore_%s" % sample]])!=-1 and int(var[fields["DistanceAfter_%s" % sample]])!=-1:
                if int(var[fields["DistanceBefore_%s" % sample]]) <= int(var[fields["DistanceAfter_%s" % sample]]):
                    #print "DistanceBefore_%s = " % sample, var[fields["DistanceBefore_%s" % sample]]
                    line = line + var[fields["DistanceBefore_%s" % sample]]
                elif int(var[fields["DistanceAfter_%s" % sample]])<= int(var[fields["DistanceBefore_%s" % sample]]):
                    #print "DistanceAfter_%s = " % sample, int(var[fields["DistanceAfter_%s" % sample]])
                    line = line + var[fields["DistanceAfter_%s" % sample]]
            else:
                if int(var[fields["DistanceBefore_%s" % sample]])==-1:
                    line = line + var[fields["DistanceAfter_%s" % sample]]
                else:
                    line = line + var[fields["DistanceBefore_%s" % sample]]

            line = line + "\n"
            out.write(line)


