import sys

# TODO: Count homozygous mutations as 2?
logfile = open(sys.argv[3], "w+")

col = 23
col -= 1


total_mutations = []
background_mutation_prob = []
genome_size = 3095693981
for line in open(sys.argv[2]):
    total_mutations.append(int(line[:-1]))
    background_mutation_prob.append(float(line[:-1])/float(genome_size))
logfile.write("[INFO] background mutation rates = %s\n" % (",".join([str(x) for x in background_mutation_prob])))
num_samples = 13

prev = None
variants = []

print ">id\tfilter\tnumber_of_mutations\thotspot_length\tmutation_probabilities"

for line in open(sys.argv[1]):
    line = line[:-1].split("\t")

    if prev:
        if line[col] != prev:
            result = [prev]
            logfile.write("Cluster id = %s\n" % prev)
            if len(variants) > 1:
                length = int(variants[-1][1]) - int(variants[0][1]) + 100
            else:
                length = 100
            if len(variants) > 2:
                probs = [(background_mutation_prob[k]**count[k])*((1-background_mutation_prob[k])**(length-count[k])) for k in range(len(count))]
                logfile.write("Number of mutations = %s\n" % str(len(variants)))
                logfile.write("Length of hotspot = %s\n" % str(length))
                logfile.write("Mutation probabilities: %s\n" % ",".join([str(x) for x in probs]))
                result.append("PASS")
                result.extend([str(len(variants)), str(length), ",".join([str(x) for x in probs])])
                #print "Number of mutations = " + str(len(variants))
                #print "Length of hotspot = " + str(length)
                #print "Mutations in hotspot per sample = ", str(count)
                summer,counter = 0,0
                included_probs = []
                for x in range(len(count)):
                    if count[x]!=0:
                        summer += probs[x]
                        counter += 1
                        included_probs.append(probs[x])
                #print included_probs, summer, counter, summer/counter
                #print "Mutation probability = ", summer/counter
            else:
                logfile.write("EXCLUDED\n")
                result.extend(["FAIL", "", "", ""])
            for variant in variants:
                logfile.write("\t".join(variant)+"\n")
            logfile.write("\n")

            """Standard output"""
            print "\t".join(result)

            variants = []
            count = [0]*num_samples
        if line[col]==prev or not variants:
            genotypes = line[9:-1]
            for x in range(len(genotypes)):
                if genotypes[x].split(":")[0] not in ["./.", "0/0"]:
                    count[x] += 1
            #print count
                    

    if not prev:
        count = [0]*num_samples
        genotypes = line[9:-1]
        for x in range(len(genotypes)):
            if "1" in genotypes[x].split(":")[0]:
                count[x] += 1
        #print count
        


    variants.append(line)

    prev = line[col]
