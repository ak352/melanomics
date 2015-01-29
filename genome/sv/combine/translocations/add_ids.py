

import sys
infile = sys.argv[1]

with open(infile) as f:
    print "id\t" + next(f)[:-1]
    id_num = 0

    for line in f:
        id_num += 1
        print str(id_num) + "\t" + line[:-1]
