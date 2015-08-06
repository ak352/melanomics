from pylab import * 
import pickle

#Creates a dictionary of fields pointing to column numbers, makes the code more readable
def ParseFields(line):
    fields = {}
    var = line.rstrip("\n").lstrip("#").lstrip(">").split("\t")
    for x in range(0, len(var)):
        fields[var[x]] = x
    return fields

def get_stats(sample):
    infile = "/work/projects/melanomics/analysis/genome/variants2/filter/patient_%d/patient_%d.testvariants.filter.annotated" % (sample, sample)

    
    counts = {}
    counts_germ = {}
    mapper = {}
    for i,k in enumerate(counts_list):
        mapper[k] =  k
        mapper[mapper_list[i]] = k
    for k in counts_list:
        counts[k] = 0
        counts_germ[k] = 0


    with open(infile) as f:
        line = next(f)
        var = ParseFields(line)

        for line in f:
            line = line[:-1].split("\t")
            ref = line[var["reference"]]
            alt = line[var["alleleSeq"]]
            vartype = line[var["varType"]]
            status = line[var["somatic_status"]]
            filt = line[var["filter"]]
            
            if vartype != "snp":
                continue
            if filt == "PASS":
                if status == "somatic":
                    counts[mapper[ref+alt]] += 1
                if status == "germline":
                    counts_germ[mapper[ref+alt]] += 1
    with open("patient_%d.obj" % sample, "wb") as handle:
        pickle.dump(counts, handle)
    with open("patient_%d.fgerm.obj" % sample, "wb") as handle:
        pickle.dump(counts_germ, handle)

def get_stats_somatic(sample):
    infile = "/work/projects/melanomics/analysis/genome/variants2/filter/patient_%d/patient_%d.somatic.testvariants.annotated" % (sample, sample)

    
    counts = {}
    mapper = {}
    for i,k in enumerate(counts_list):
        mapper[k] =  k
        mapper[mapper_list[i]] = k
    for k in counts_list:
        counts[k] = 0


    with open(infile) as f:
        line = next(f)
        var = ParseFields(line)

        for line in f:
            line = line[:-1].split("\t")
            ref = line[var["reference"]]
            alt = line[var["alleleSeq"]]
            vartype = line[var["varType"]]
            
            if vartype != "snp":
                continue
            counts[mapper[ref+alt]] += 1
    with open("patient_%d.somatic.obj" % sample, "wb") as handle:
        pickle.dump(counts, handle)


def plotter(sample, idx, caller):
    if caller=="fasd_germline":
        with open("patient_%d.fgerm.obj" % sample, "rb") as handle:
            counts = pickle.load(handle)

    if caller=="fasd_somatic":
        with open("patient_%d.obj" % sample, "rb") as handle:
            counts = pickle.load(handle)
    if caller=="somatic_caller":
        with open("patient_%d.somatic.obj" % sample, "rb") as handle:
            counts = pickle.load(handle)

    
    counter = []
    for k in counts_list:
        counter.append(counts[k])
    bar(arange(len(counts_list)), counter, color=colors)
    xticks(arange(len(counts_list))+0.5, [x[0][0]+">"+x[0][1]+"\n"+x[1][0]+">"+x[1][1] for x in zip(counts_list, mapper_list)])
    title("patient_%d (%s)" % (sample, caller))
    ylabel("Number of SNVs")
    xlabel("Nucleotide change")

if __name__ == "__main__":
    counts_list = ["TG", "TC", "TA", "CT", "CG", "CA"]
    mapper_list = ["AC", "AG", "AT", "GA", "GC", "GT"]
    colors = ["r", "g", "b", "y", "magenta", "cyan", "orange"]
    
    samples = [2,4,5,6,7,8]
    figure(figsize = (22,20))
    for idx, sample in enumerate(samples):
        # sys.stderr.write("Counting for sample %d...\n" % sample)
        # get_stats(sample)
        # sys.stderr.write("Counting somatic SNVs for sample %d...\n" % sample)
        # get_stats_somatic(sample)
        sys.stderr.write("Plotting for sample %d...\n" % sample)
        subplot(2,3,idx+1)
        plotter(sample, idx, "fasd_somatic")
    outfile = "/work/projects/melanomics/analysis/genome/variants2/filter/graphs/nucleotide/fasd_somatic.pdf"
    sys.stderr.write("Plot saved at %s\n" % outfile)
    savefig(outfile, bbox_inches="tight")

    figure(figsize = (22,20))
    for idx, sample in enumerate(samples):
        subplot(2,3,idx+1)
        plotter(sample, idx, "somatic_caller")
    outfile = "/work/projects/melanomics/analysis/genome/variants2/filter/graphs/nucleotide/somatic_caller.pdf"
    sys.stderr.write("Plot saved at %s\n" % outfile)
    savefig(outfile, bbox_inches="tight")

    figure(figsize = (22,20))
    for idx, sample in enumerate(samples):
        subplot(2,3,idx+1)
        plotter(sample, idx, "fasd_germline")
    outfile = "/work/projects/melanomics/analysis/genome/variants2/filter/graphs/nucleotide/fasd_germline.pdf"
    sys.stderr.write("Plot saved at %s\n" % outfile)
    savefig(outfile, bbox_inches="tight")



    #show()
