import re
import pandas as pd
import numpy as np


def mapping_time(infile, times):
    total_reads = 0
    for line in open(infile):
        seqs = re.findall('read ([0-9]+) sequences', line) 
        if seqs:
            total_reads += int(seqs[0])
        if "bwa mem" in line:
            cores = int(re.findall('-t ([0-9]+)', line)[0])
            
        if "Real" in line:
            line = line[7:-1].split(";")
            x = line[0]
            x = x.split(":")
            seconds = float(x[1][:-4].strip())
                
    times.append((total_reads, cores, seconds/3600, seconds*1000000/(total_reads)))
    return times

infiles = [line[:-1] for line in open("mapping.patient_2_NS")]

times = []
for infile in infiles[:]:
    times = mapping_time(infile, times)

    
map_time = pd.DataFrame(np.array(times), columns=["reads", "cores", "real time(h)", "real time(s/Mbp reads)"])
print(map_time)
map_time.plot()

