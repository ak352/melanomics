from pylab import *

samples = ["patient_"+str(k) for k in [2,4,5,6,7,8]]
infiles = []

def plot_scores(infile):
    scores = {}
    k = 0
    for line in open(infile):
        line = line[:-1].split("\t")
        score = float(line[7])

        svtype = line[10].split(":")[1]
        
        ids = line[11][4:].split(";")
        id_set = set()
        for iden in ids:
            id_set.add(iden.split(",")[0])

        """ Plot only somatic SVs """
        if "2" in id_set and "1" not in id_set:
            if svtype not in scores:
                scores[svtype] = []
            if score != float("inf") and score != float("-inf"):
                if score == 0:
                    score = -1000
                else:
                    score = log(score)/log(10)
                scores[svtype].append(score)
        k+=1
    return scores


for sample in samples:
    infile = "/work/projects/melanomics/analysis/genome/lumpy_genome/trim/%s.tumor_v_normal.pesr.bedpe" % sample
    scores = plot_scores(infile)

    m = 0
    figure()
    for svtype in scores:
        m += 1
        subplot(2,2,m)
        nbins,x = histogram(scores[svtype], bins=100)
        #print len(x), len(nbins)
        bincenters = 0.5*(x[1:]+x[:-1])
        plot(bincenters, nbins)
        print "%s:%s" % (sample, svtype)
        print "Min = ", min(scores[svtype])
        print "Max = ", max(scores[svtype])

        title("%s:%s" % (sample, svtype))

#for k in scores["DELETION"]:
#    print k
#print "%s: %s" % (svtype, str(len(scores[svtype])))
show()

