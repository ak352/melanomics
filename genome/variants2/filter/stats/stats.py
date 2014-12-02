import sys
import json
import samples


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

def update(line, var, sample, total_count, any_filter, counts):
    vartype = line[var["varType"]]
    if sample not in total_count:
        total_count[sample] = {}
    if vartype not in total_count[sample]:
        total_count[sample][vartype] = 0
    total_count[sample][vartype] += 1
    total_count[sample]["variants"] += 1

    """ Count variants that are filtered by each filter """
    is_filtered = False
    for filt in filters:
        if line[var[filt]]:
            is_filtered = True
            if sample not in counts:
                counts[sample] = {}
            if filt not in counts[sample]:
                counts[sample][filt] = {}
                counts[sample][filt]["variants"] = 0
            if vartype not in counts[sample][filt]:
                counts[sample][filt][vartype] = 0
            counts[sample][filt][vartype] += 1
            counts[sample][filt]["variants"] += 1
        
    """ Count variants that have been filtered by any of the filters """
    if is_filtered:
        if sample not in any_filter:
            any_filter[sample] = {}
        if vartype not in any_filter[sample]:
            any_filter[sample][vartype] = 0
        any_filter[sample][vartype] += 1
        any_filter[sample]["variants"] += 1
    return total_count, any_filter, counts 

if __name__ == "__main__":
    infile = "/work/projects/melanomics/analysis/genome/variants2/filter/all.out"
    outfile = "/work/projects/melanomics/analysis/genome/variants2/filter/all.stats.json"
    # infile = "/work/projects/melanomics/analysis/genome/variants2/filter/hp_ms_rm_sr_sd/all.hp_ms_rm_sr_sd.out"
    # outfile = "/work/projects/melanomics/analysis/genome/variants2/filter/hp_ms_rm_sr_sd/all.hp_ms_rm_sr_sd.stats.json" 
    filters = ["Homopolymer", "microsatellites", "repeat masker", "segmental duplication", "self-chained regions"]
    samples = samples.get_samples()
                   
    total_count = {}
    any_filter = {}
    counts = {}
    for k in [total_count, any_filter]:
        for m in samples:
            k[m] = {}
    for sample in samples:
        total_count[sample]["variants"] = 0
        any_filter[sample]["variants"] = 0



    total = 0
    for line in open(infile):
        if line[0] in "v>#":
            var = ParseFields(line)
        else:
            line = Strip(line)
            for sample in samples:
                if "1" in line[var[sample]]:
                    total_count, any_filter, counts = update(line, var, sample, total_count, any_filter, counts)

            total+=1    
            if total % 1000000 == 0:
                sys.stderr.write("Processed %d variants\n" % total)

    """Store a list [total_count, any_filter, counts] """
    with open(outfile, "w") as outfile:
        json.dump((total_count, any_filter, counts), outfile, indent=2)
        
