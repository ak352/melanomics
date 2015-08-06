import sys
def ParseFields(line):
    var = {}
    line = line[:-1].lstrip(">").split("\t")
    for i,x in enumerate(line):
        var[x] = i
        
    return var


infile = sys.argv[1]
with open(infile) as f:
    line = next(f)
    var = ParseFields(line)
    #print "chrom\tbegin\tend\t" + line[:-1]


    has_acc = 0
    has_site = 0
    has_pmid = 0
    has_skin = 0
    has_skin_pmid = 0
    total = 0
    pmids = set()
    #sys.stderr.write("Keys = %s\n" % ",".join(var.keys()))
    
    for line in f:
        line = line[:-1].split("\t")
        acc = line[var["Accession Number"]]
        site = line[var["Primary site"]]
        pmid = line[var["Pubmed_PMID"]]
        total += 1
        if acc:
            has_acc += 1
        if site:
            has_site += 1
        if pmid:
            has_pmid += 1
            pmid_list = pmid.split(";")
            pmids = pmids.union(set(pmid_list))

        if site:
            site = site.split(";")
            if "skin" in site:
                has_skin += 1
                if pmid:
                    has_skin_pmid += 1
    



print("SUMMARY:")
print("Total mutations = %d" % total)
print("Mutations that have a COSMIC Accession Number = %d" % has_acc)
print("Mutations that have a COSMIC Primary Site = %d" % has_site)
print("Mutations that have a COSMIC Pubmed_PMID = %d" % has_pmid)
print("Mutations also found in COSMIC on skin as primary site   = %d" % has_skin)
print("Mutations also found in COSMIC on skin as primary site and have a Pubmed_PMID = %d" % has_skin_pmid)

print("Number of unique PUBMED IDS annotated = %d" % len(pmids))






