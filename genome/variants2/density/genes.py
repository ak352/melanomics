""" Takes the mutation mapping to cdna coordinates """
""" and outputs the number of mutations per gene """
""" and mutation density per gene """

infile = "/home/users/akrishna/scripts/shsy5y/cdna/cpp/cdna_results.cdna_sorted"
count = {}
for line in open(infile):
    line = line.strip("\n").split("\t")
    transcript = line[10]
    """Homozygous in all platforms or not"""
    both_hom = line[8] == "11" and line[9] == "11"
    homozygous = both_hom
    
    if transcript not in count:
        count[transcript] = 0
    if homozygous:
        count[transcript] += 2
    else:
        count[transcript] += 1



