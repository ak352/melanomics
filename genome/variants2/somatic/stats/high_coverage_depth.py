import numpy as np

def get_thresh(sample):
    infile="/work/projects/melanomics/analysis/genome/variants2/somatic/stats/patient_%s.depth.hist" % sample
    outfile="/work/projects/melanomics/analysis/genome/variants2/somatic/stats/patient_%s.depth.hist.max_coverage_depth" % sample
    rds = []
    for line in open(infile):
        line = [int(x) for x in line[:-1].split(" ")]
        [x, rd] = line[0:2]
        rds.append(float(rd))
    cumrd = np.cumsum(np.asarray(rds))
    cumrd_norm=cumrd/sum(rds)
    for i,y in enumerate(cumrd_norm):
        x=i+1
        if y >= 0.995:
            return x, y, cumrd[i]


if __name__ == "__main__":
    samples = [2,4,5,6,7,8]
    for sample in samples:
        print sample
        print get_thresh(sample)

 

