import sys


hits = 0
hits_50 = 0
segments = 0
with open(sys.argv[1]) as f:
    line = next(f)[:-1].split("\t")
    sys.stderr.write("Getting summary for field: %s\n" % line[5])
    for line in f:
        line = line[:-1].split("\t")
        variantId = line[5]
        
        if variantId:
            variantId = variantId.split(";")
            
            hits += 1
        segments += 1

sys.stderr.write("SUMMARY:\n")
sys.stderr.write("Regions that overlap a DGV entry: %d/%d (%2.2f %%)\n" % (hits, segments, float(hits)*100/float(segments)))


