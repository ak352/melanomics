import sys

out = open(sys.argv[2], "w+")

file = open(sys.argv[1])
for line in file:
    if line.startswith(">"):
        out.write(line)
        break
file.close()


file = open(sys.argv[1]).readlines()

for line in reversed(file):
    if not line.startswith(">"):
        out.write(line)

                         
