import sys
import pandas as pd
import numpy as np
            
def report(line, log):
    for s in sys.stderr, log:
        s.write(line)


def get_novel(infile):
    cnv_r = pd.read_csv(infile, delimiter="\t", chunksize=500)

    summer = 0
    for cnv in cnv_r:
        x = cnv[pd.isnull(cnv["variantaccession"])]
        summer += (x["end"] - x["begin"]).sum()
    print(summer)
        

if __name__ == "__main__":
    ps = [2,4,6,7,8]
    patients = ["patient_%d" % k for k in ps]
    infiles = ["/work/projects/melanomics/analysis/genome/abscnseq/P%d.cnv.adj.called.wheader.dgv" % p for p in ps]
    novel = pd.DataFrame(np.zeros((1,len(ps))), columns=patients)

    for i,k in enumerate(patients):
        novel[k] = get_novel(infiles[i])

    novel.hist('barh')
    
