import sys
import time
 
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

def revers(string):
    string = string.split("_")
    newstr = [string[-1]]
    newstr.extend(string[:-1])
    return "_".join(newstr)
    

if __name__ == "__main__":
    # infile = "/work/projects/melanomics/analysis/genome/variants2/filter/hp_ms_rm_sr_sd/all.hp_ms_rm_sr_sd.out"
    # outfile="/work/projects/melanomics/analysis/genome/variants2/filter/hp_ms_rm_sr_sd/all.hp_ms_rm_sr_sd.cov_qual.out"
    # infile = "/work/projects/melanomics/analysis/genome/variants2/filter/all.out"
    # outfile="/work/projects/melanomics/analysis/genome/variants2/filter/all.filter_annotation.out"
    # filter_file = "/work/projects/melanomics/analysis/genome/variants2/filter/graphs/hp_ms_rm_sr_sd_absolute_germline_only/roc/filter_values_for_input"

    infile = sys.argv[1]
    outfile = sys.argv[2]
    filter_file = sys.argv[3]

    regional_filters = ["Homopolymer", "microsatellites", "repeat masker", "segmental duplication", "self-chained regions"]
    # regional_filters = ["Homopolymer", "microsatellites", "segmental duplication"]
    logfile=open(outfile+".log", "w")
    logfile.write(time.strftime("[%d-%m-%Y, %H:%M:%S] Begin filtering...\n"))
    out = open(outfile, "w+")

    num_filtered = 0

    # Extract the filter values
    filters = {}
    with open(filter_file) as f:
        line = next(f)
        var = ParseFields(line)
        for line in f:
            line = StripLeadLag(line)
            field = line[var["fields"]]
            thresh = line[var["min_thresh"]]
            if "coverage" in field or "quality" in field:
                filters[field] = float(thresh)
                


    # print filters
    vartypes = ["variants", "snp", "ins", "del", "sub"]

    with open(infile) as f:
        line = next(f)
        var = ParseFields(line)
        out.write(line[:-1] + "\tfilter\treasons_for_filtering\n")
    
        num_passed = {}
        num_filtered = {}
        count = {}
        for key in vartypes:
            num_passed[key] = 0
            num_filtered[key] = 0
            count[key] = 0
        total = 0

        for line in f:
            line = StripLeadLag(line)
            reasons = []
            is_filter = False
            vartype = line[var["varType"]]

            for filt in filters:
                if "coverage" in filt:
                    # print filt
                    if float(line[var[filt]]) < float(filters[filt]) and float(line[var[filt]]) <= 200:
                        is_filter = True
                        reasons.append("%s=%s" % (filt, line[var[filt]]))

                if "indelsub.quality" in filt:
                    if vartype in ["ins", "del", "sub"]:
                        thresh = float(filters[filt])
                        filt = filt.replace("indelsub.", "")
                        if float(line[var[filt]]) < thresh:
                            is_filter = True
                            reasons.append("%s=%s" % (filt, line[var[filt]]))

                if "snp.quality" in filt:
                    if vartype == "snp":
                        thresh = float(filters[filt])
                        filt = filt.replace("snp.", "")
                        if float(line[var[filt]]) < thresh:
                            is_filter = True
                            reasons.append("%s=%s" % (filt, line[var[filt]]))
                for filt in regional_filters:
                    if line[var[filt]]:
                        is_filter = True
                        reasons.append("%s=%s" % (filt, line[var[filt]]))

            if is_filter:
                line.extend(["FAIL", ";".join(reasons)])
                num_filtered[vartype] += 1
                num_filtered["variants"]
            else:
                line.extend(["PASS", ""])
                num_passed[vartype] += 1
                num_passed["variants"] += 1
            count[vartype] += 1
            count["variants"] += 1
            out.write("\t".join(line)+"\n")

            total += 1
            if total % 1000000 == 0:
                logfile.write("%d variants processed..., pass rate = %4.2f (snp=%4.2f, ins=%4.2f, del=%4.2f, sub=%4.2f)\n" % (total, \
                                                                                                                                     float(num_passed["variants"])/float(total), \
                                                                                                                                     float(num_passed["snp"])/float(count["snp"]), \
                                                                                                                                     float(num_passed["ins"])/float(count["ins"]), \
                                                                                                                                     float(num_passed["del"])/float(count["del"]), \
                                                                                                                                     float(num_passed["sub"])/float(count["sub"]), \
                                                                                                                                     ))
        logfile.write("Output written to %s\n" % outfile)
        logfile.write("Filter statistics:\n")
        logfile.write("Variant type\tTotal\tPassed\tFailed\tPass rate\n")
        for var in vartypes:
            logfile.write("%s\t%d\t%d\t%d\t%4.4f\n" % (var, count[var], num_passed[var], num_filtered[var], float(num_passed[var])/float(count[var]) ))

    logfile.write(time.strftime("[%d-%m-%Y, %H:%M:%S] Filtering done.\n"))


        
