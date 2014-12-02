import json
import samples as sp

infile=open("/work/projects/melanomics/analysis/genome/variants2/filter/all.stats.json")
total_count, any_filter, counts = json.load(infile)


#print total_count, any_filter, counts
samples = sp.get_samples()
vartypes=["variants", "snp", "ins", "del"]
filters = ["Homopolymer", "microsatellites", "repeat masker", "segmental duplication", "self-chained regions"]

print "Sample\tFilter\tVariant type\tCount"
for sample in samples:
    for vartype in vartypes:
        print "%s\tAll variants\t%s\t%s" % (sample, vartype, total_count.get(sample, {}).get(vartype, 0))
    for vartype in vartypes:
        print "%s\tFiltered\t%s\t%s" % (sample, vartype, any_filter.get(sample, {}).get(vartype, 0))
 
    for filt in filters:
        for vartype in vartypes:
            print "%s\t%s\t%s\t%s" % (sample, filt, vartype, counts.get(sample, {}).get(filt, {}).get(vartype, 0))

