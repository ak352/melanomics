import sys
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.mplot3d import proj3d


mds = "plink.mds.delim"
points = np.zeros((13,4))
#print points

labels = []
with open(mds) as f:
    next(f)
    
    for i,line in enumerate(f):
        line = line[:-1].split("\t")
        labels.append(line[1])
        points[i, :] = np.array([float(x) for x in line[4:8]])

#fig = plt.figure()
#ax = Axes3D(plt.gcf())
colors = ["orange", "red", "blue", "green", "yellow", "magenta", "black"]
# for k in range(3):
#     ranges = range(2*k+1, 2*k+3)
#     print ranges
#     ax.scatter(points[ranges,0], points[ranges,1], points[ranges,2], c=colors[k])
# ax.set_xlabel("C1")
# ax.set_ylabel("C2")
# ax.set_zlabel("C3")

samps = [str(k) for k in [2,4,5,6,7,8]]
samples = ["NHEM"]
for s in samps:
    for m in ["PM", "NS"]:
        samples.append(s+m)

plt.figure()
plt.plot(points[0,1], points[0,2], color=colors[0], ms=10, marker='o', label=samples[0])
#plt.annotate(samples[0], xy=(points[0,1], points[0,2]), xytext=(points[0,1], points[0,2]+0.005))

for k in range(6):
    ranges = range(2*k+1, 2*k+3)
    plt.plot(points[2*k+1,1], points[2*k+1,2], color=colors[k+1], ms=10, marker='o', label=samples[2*k+1])
    plt.plot(points[2*k+2,1], points[2*k+2,2], color=colors[k+1], ms=10, marker="D", label=samples[2*k+2])
    #plt.annotate(samples[2*k+1], xy=(points[ranges[0],1], points[ranges[0],2]), xytext=(points[ranges[0],1], points[ranges[0],2]+0.005))
    #plt.annotate(samples[2*k+2], xy=(points[ranges[1],1], points[ranges[1],2]), xytext=(points[ranges[1],1], points[ranges[1],2]+0.005))

plt.xlabel("Component 1")
plt.ylabel("Component 2")
#plt.xrange([-0.01,0.01])
plt.legend(loc=2, prop={'size':12})

plt.savefig("mds.pdf", bbox_inches="tight", figsize=(8,11), dpi=80)
#plt.show()


    
    
