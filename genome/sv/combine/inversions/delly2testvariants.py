from pylab import *
import os

#Creates a dictionary of fields pointing to column numbers, makes the code more readable
def ParseFields(line):
    fields = {}
    var = line.rstrip("\n").lstrip("#").lstrip(">").split("\t")
    for x in range(0, len(var)):
        fields[var[x]] = x
    return fields

def lg(num):
    return log(num)/log(10)

def is_somatic(g1, g2):
    g1 = g1.split(":")[0]
    g2 = g2.split(":")[0]
    is_somatic=False
    if g1 not in ["./.", ".", "0/0"]:
        return is_somatic
    if g2 in ["./.", ".", "0/0"]:
        return is_somatic

    # If g1 has no ALT allele and g2 has an ALT allele, 
    # return True, else False
    return True
    

def get_delly_deletions(infile, outfile, logfile):
    out = open(outfile, "w")
    out.write("chrom\tbegin\tend\n")

    count_all = 0
    count_somatic = 0

    with open(infile) as f:
        line = "##"
        while line.startswith("##"):
            line = next(f)
        header = line
        var = ParseFields(header)

        svlens = []
        svlens_all_qual = []
        for line in f:
            line = line[:-1].split("\t")
            info = line[var["INFO"]].split(";")
            fields = {}
            for item in info:
                item = item.split("=")
                if len(item) > 1:
                    fields[item[0]] = item[1]
            # print line[var["CHROM"]], line[var["POS"]], fields["CHR2"], fields["END"], fields["SVLEN"]
            chrom = line[var["CHROM"]]
            begin = int(line[var["POS"]])
            end = int(fields["END"])
            
            svlen = int(fields["SVLEN"])
            if line[var["FILTER"]] != "LowQual":
                # Check if somatic
                if is_somatic(line[9], line[10]):
                    svlens.append(svlen)
                    outline = [chrom, str(begin), str(end)]
                    out.write("\t".join(outline)+"\n")
                    count_somatic += 1
                count_all += 1

            svlens_all_qual.append(svlen)

    logfile.write("\t%d\t%d\n" % (count_somatic, count_all))
    y, nbins = histogram(svlens, 100)
    y2, nbins2 = histogram(svlens_all_qual, 100)
    nbins = (nbins[1:]+nbins[:-1])/2
    nbins2 = (nbins2[1:]+nbins2[:-1])/2
    return (nbins, y), (nbins2, y2)


if __name__=="__main__":
    samples = [2,4,5,6,7,8]
    logfile = "/work/projects/melanomics/analysis/genome/sv/delly/delly.testvariants.log"
    log = open(logfile, "w")
    log.write("patient\tSV type\tsomatic\tall\n")

    svtypes = ["DEL", "DUP", "INV", "TRA"]
    svtype_full = ["DELETION", "DUPLICATION", "INVERSION", "INTERCHROM"]

    for sample in samples:
        for i,svtype in enumerate(svtypes):
            infile="/work/projects/melanomics/analysis/genome/sv/delly/patient_%d/final/patient_%d_PM.%s.vcf" % (sample, sample, svtype)
            if not os.path.isfile(infile):
                continue
            outfile="/work/projects/melanomics/analysis/genome/sv/delly/patient_%d/final/patient_%d_PM.%s.testvariants" % (sample, sample, svtype)
            log.write("patient_%d\t%s" % (sample, svtype_full[i]))
            highq, alldel = get_delly_deletions(infile, outfile, log)    
            sys.stderr.write("Output written to %s\n" % outfile)

    sys.stderr.write("Log output file: %s\n" % logfile)



    # subplot(2,3,i+1)
    # plot(lg(highq[0]), lg(highq[1]), label="DELLY_HQ", lw=3)
    # plot(lg(alldel[0]), lg(alldel[1]), label="DELLY", lw=3)
    # sample = 2
    # title("patient_%d" % sample)
    # xlabel("log(Size of deletions (bp))")
    # ylabel("log(Number of variants)")
    # legend()
    # show()
