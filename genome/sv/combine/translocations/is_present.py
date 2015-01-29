import fileinput
import sys
""" Checks if both the first and second column has equal values (ids) and if yes, prints 1, else 0 """

if __name__=="__main__":
    f = fileinput.input()
    sample = next(f)[:-1]
    print sample #""\t".join(new_header)

    #Ignore header = ">Id"
    next(f)

    sys.stderr.write("Checking if both mates in list match the same fragment in the tested sample...\n")
    ids_found = set()

    for line in f:
        line = line[:-1].split("\t")
        has_overlap = False

        if line[0]:
            ids = [x.split(":")[0] for x in line[0]]
            for iden in ids:
                ids_found.add(iden)

            ids = [x.split(":")[0] for x in line[1]]
            for iden in ids:
                if iden in ids_found:
                    has_overlap = True

        if has_overlap:
            print 1
        else:
            print 0

    
