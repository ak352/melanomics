import sys
""" Usage: python prepare_test.py <svJunctions-file> """
""" Takes a translocation file of the format "chrom1 chrom2 pos1 pos2" file and swaps (chrom1, pos1) and (chrom2, pos2) such that chrom1 <= chrom2 (according to a defined ordering 1<2<...<22<X<Y<MT)"""
""" Only prints translocations, i.e. chrom1!=chrom2 """

#Creates a dictionary of fields pointing to column numbers, makes the code more readable
def ParseFields(line):
    fields = {}
    var = line.rstrip("\n").lstrip("#").lstrip(">").split("\t")
    for x in range(0, len(var)):
        fields[var[x]] = x
    return fields

chromosome_order = [str(x) for x in range(1,23)]
chromosome_order.extend(["X","Y","MT"])
chromosomes = dict((x,i) for i,x in enumerate(chromosome_order))

overlap_threshold = 100000
sys.stderr.write("Translocation overlap threshold = %d bp\n" % overlap_threshold)



if __name__=="__main__":
    infile = sys.argv[1]
    with open(infile) as f:
        line = next(f)
        new_fields = ["LeftChrSorted", "RightChrSorted", "LeftPosBegin", "LeftPosEnd", "RightPosBegin", "RightPosEnd"]
        sys.stderr.write("Adding fields %s\n" % ",".join(new_fields))
        print "id\t" + line[:-1]+"\t" + "\t".join(new_fields)

        id_num = 0
        var = ParseFields(line)
        for line in f:
            line = line[:-1].split("\t")

            # Take only translocations from SVs
            if line[var["chrom1"]]!=line[var["chrom2"]]:
                # Use a window around the junction to compare across samples 
                left_pos = int(line[var["pos1"]])
                right_pos = int(line[var["pos2"]])
                left_pos_range = [str(x) for x in [left_pos-overlap_threshold,left_pos+overlap_threshold]]
                right_pos_range = [str(x) for x in [right_pos-overlap_threshold,right_pos+overlap_threshold]]

                # Ensure that left chromosome is always of lower index than the right chromosome
                # Will avoid comparing left to right chromosome and vice-versa across samples
                if chromosomes[line[var["chrom1"]]] > chromosomes[line[var["chrom2"]]]:
                    line.extend([line[var["chrom2"]], line[var["chrom1"]]])
                    line.extend(right_pos_range)
                    line.extend(left_pos_range)
                else:
                    line.extend([line[var["chrom1"]], line[var["chrom2"]]])
                    line.extend(left_pos_range)
                    line.extend(right_pos_range)
                
                id_num += 1
                newline = [str(id_num)]
                newline.extend(line)
                print "\t".join(newline)
            
