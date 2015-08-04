import sys


try:
    #Skip the first 9 fields
    sample_index = int(sys.argv[2])+8
    sys.stderr.write("INFO: Sample index = " + sys.argv[2] + "\n")
except ValueError:
    sys.stderr.write("2nd argument must be an integer\n")
    sys.exit()

for line in open(sys.argv[1]):
    if line.startswith("#"):
        print line.rstrip("\n")
    else:
        line = line.rstrip("\n").split("\t")
        dp_found = False
        for x in line[7].split(";"):
            if x.split("=")[0] == "DP":
                dp_found = True
                try:
                    #Get the depth
                    depth = x.split("=")[1]
                    #Remove depth info from info field
                    y = line[7].rsplit(";")
                    y.remove(x)
                    line[7] = ";".join(y)
                    
                except ValueError:
                    sys.stderr.write("ERROR: Non-integer depth in line " + "\t".join(line) + "\n")
                    sys.exit()
                    
        if not dp_found:
            #If no DP value in INFO, DP=0
            depth = "0"

        num_fields = len(line[8].split(":"))
        genotype = line[sample_index].split(":")
        #Extend the genotype field to correspond to the number of format fields
        for k in range(len(genotype), num_fields):
            genotype.append(".")

        depth_index = None
        for k in range(len(line[8].split(":"))):
            if line[8].split(":")[k]=="DP":
                depth_index = k
        if depth_index:
            if genotype[depth_index] == ".":
                genotype[depth_index] = depth
        else:
            genotype.append(depth)
            line[8] += ":DP"
        
        line[sample_index] = ":".join(genotype)

        print "\t".join(line)
