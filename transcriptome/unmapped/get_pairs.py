import sys
import fileinput

def write(buf):
    for line in buf:
        print "\t".join(line)


if __name__=="__main__":
    k = 0
    count = 0
    prev = [""]
    for line in fileinput.input():
        line = line[:-1].split("\t")
        
        if line[0] == prev[0]:
            count += 1
            buf.append(line)
        elif line[0] != prev[0]:
            if count > 1:
                write(buf)
            count = 1
            buf = [line]

        prev = line


