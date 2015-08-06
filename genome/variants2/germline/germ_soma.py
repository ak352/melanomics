import sys

def germ_soma(normal, tumor):
    for x in [normal, tumor]:
        assert x in ["00", "11", "01", "NN"], x
    
    germline = ("germline", [["11", "11"],
                ["01", "01"],
                ["11", "01"],
                ["01", "11"]])
    possibly_germline = ("possibly_germline", [["11", "NN"],
                         ["01", "NN"]])

    # These are mostly errors, so should be low
    only_germline = ("only_germline", [["01", "00"],
                     ["11", "00"]])

    somatic = ("somatic", [["00", "01"],
               ["00", "11"]])
    possibly_somatic = ("possibly_somatic", [["NN", "11"],
                        ["NN", "01"]])
    
    for x in [germline, possibly_germline, only_germline, somatic, possibly_somatic]:
        if [normal, tumor] in x[1]:
            return x[0]

if __name__ == "__main__":
    infile = sys.argv[1]
    col1 = 8
    col2 = 9
    sys.stderr.write("Using columns %d and %d for normal and tumor genotypes.\n" % (col1+1, col2+1))
    with open(infile) as f:
        next(f)
        print "somatic_status"
        for line in f:
            line = line[:-1].split("\t")
            
            # print line[col1], line[col2], 
            print germ_soma(line[col1], line[col2])
        

    
    
                         
