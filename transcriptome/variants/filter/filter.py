import sys

case = sys.argv[2].split(",")
control = sys.argv[3].split(",")


for line in open(sys.argv[1]):
    if line.startswith("#"):
        continue
    line = line.rstrip("\n").split("\t")

    
    "All cases have a variant"
    cases_variant = True
    for k in case:
        sample = line[int(k)-1]
        sample = sample[0:3]
        if sample == "0/0" or "." in sample:
            cases_variant = False
    control_ref = True
    for k in control:
        sample = line[int(k)-1]
        sample = sample[0:3]
        if sample != "0/0":
            control_ref = False
    if cases_variant and control_ref:
        line.append("cases_variant_control_ref")
    else:
        line.append("-")
    print "\t".join(line)

        
            
