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
        points[i, :] = np.array([float(x) for x in line[3:7]])

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

samples = [l.split("_")[1]+l.split("_")[2] for l in labels]

plt.figure()
#plt.annotate(samples[0], xy=(points[0,1], points[0,2]), xytext=(points[0,1], points[0,2]+0.005))

for k in range(6):
    ranges = range(2*k, 2*k+2)
    plt.plot(points[2*k,1], points[2*k,2], color=colors[k], ms=10, marker='o', label=samples[2*k], alpha=0.5)
    plt.plot(points[2*k+1,1], points[2*k+1,2], color=colors[k], ms=15, marker="D", label=samples[2*k+1], alpha=0.5)

plt.xlabel("Component 1")
plt.ylabel("Component 2")
#plt.xrange([-0.01,0.01])
plt.legend(loc=1, prop={'size':12})

plt.savefig("mds.pdf", bbox_inches="tight", figsize=(8,11), dpi=80)
#plt.show()


    
    
