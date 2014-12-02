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


out = open("output/nearest_hp_before", "w+")
#file = open("../master.GS00533.GS00003432.SS6002862.tested.illumina")
file = open("hp_var_merged.sorted")

current = []


for line in file:
    var = StripLeadLag(line)
    if line.startswith(">"):
        fields = ParseFields(line)
        out.write(line.rstrip("\n")+"\tvariantIdNearestBefore\tDistanceBefore\n")
    else:
        
        if var[fields["variantId"]]=="hp":
            current = var

        #Print the homopolymers as they will be needed to record closest homopolymer after variant 
        if var[fields["variantId"]]=="hp":
            out.write(line)

        

        if var[fields["variantId"]]!="hp":

            #If no homopolymer encountered yet, set distance = -1, and move on to the next variant                                                                                      
            if current == []:
                var.append("-1")
                var.append("-1")
                out.write("\t".join(var)+"\n")
                continue


            if var[fields["chromosome"]]==current[fields["chromosome"]]:
                var.append(";".join(current))
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
        
file.close()
out.close()

#Reverse the order of the variants
os.system("python reverse_file.py output/nearest_hp_before output/nearest_hp_before.reversed")

out = open("output/nearest_hp.reversed.annotated", "w+")
file = open("output/nearest_hp_before.reversed")

current = []

for line in file:
    var = StripLeadLag(line)
    if line.startswith(">"):
        fields = ParseFields(line)
        out.write(line.rstrip("\n")+"\tvariantIdNearestAfter\tDistanceAfter\n")
    else:
        if var[fields["variantId"]]=="hp":
            current = var
        
        #Print the homopolymers as they will be needed to record closest homopolymer after variant                                                                                                                                       
        if var[fields["variantId"]]=="hp":
            out.write(line)



        if var[fields["variantId"]]!="hp":

            #If no indel encountered yet, set distance = -1, and move on to the next variant                                                                                     
            if current == []:
                var.append("-1")
                var.append("-1")
                out.write("\t".join(var)+"\n")
                continue

            #If indel encountered, label the distance to that indel
            if var[fields["chromosome"]]==current[fields["chromosome"]]:
                var.append(";".join(current))

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

file.close()
out.close()
#Reverse the order of the variants to get the original order
os.system("python reverse_file.py output/nearest_hp.reversed.annotated output/nearest_hp")       
               

#Choose the indel before or the indel after snp as the nearest indel
file = open("output/nearest_hp")
out = open(sys.argv[1], "w+")
for line in file:
    var = StripLeadLag(line)
    if line.startswith(">"):
        fields = ParseFields(line)
        out.write(">" + "\t".join(var[:-4] )+ "\tNearestHpDistance\n")

    else:


        
        if var[fields["variantId"]]!="hp":
            line = "\t".join(var[:-4]) + "\t"

            assert (int(var[fields["DistanceBefore"]])!=-1 or int(var[fields["DistanceAfter"]])!=-1), "No homopolymer region in chromosome"

            #If there are homopolymer regions before and after the variant, compare the distances
            if int(var[fields["DistanceBefore"]])!=-1 and int(var[fields["DistanceAfter"]])!=-1:
                
                if int(var[fields["DistanceBefore"]]) <= int(var[fields["DistanceAfter"]]):
                    print "DistanceBefore = ", var[fields["DistanceBefore"]]
                    line = line + var[fields["DistanceBefore"]] 
                    
                elif int(var[fields["DistanceAfter"]])<= int(var[fields["DistanceBefore"]]):
                    print "DistanceAfter = ", int(var[fields["DistanceAfter"]])
                    line = line + var[fields["DistanceAfter"]] 

            else:
                if int(var[fields["DistanceBefore"]])==-1:
                    line = line + var[fields["DistanceAfter"]]
                else:
                    line = line + var[fields["DistanceBefore"]]

            line = line + "\n"
            out.write(line)


