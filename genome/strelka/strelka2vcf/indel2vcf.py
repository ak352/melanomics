import sys
from collections import Counter

def indel2GT(sgt):
    assert sgt in ['hom', 'het'], sgt
    if sgt == 'hom':
        return '1/1'
    elif sgt == 'het':
        return '0/1'

def report(line, log):
    sys.stderr.write(line)
    log.write(line)

def fail_filter(normal, tumor):
    if int(normal['DP']) < 8 or int(tumor['DP']) < 14:
        return True
    return False

    
if __name__=="__main__":
    inputs = open("input", "r")
    num_input = int(inputs.readline()[:-1])
    for k in range(num_input):
        infile=inputs.readline()[:-1]
        outfile_name = inputs.readline()[:-1]
        variant_type = inputs.readline()[:-1]
        sample_name = inputs.readline()[:-1]
        outfile = open(outfile_name, "w+")
        logfile = outfile_name + ".log"
        log = open(logfile, 'w')

        if variant_type == "snp":
            report("[INFO] Variant type = snp\n", log)
        elif variant_type == "indel":
            report("[INFO] Variant type = indel\n", log)
        else:
            report("[WARNING] Variant type must be snp or indel\n", log) 
            continue

        report("[INFO] Input: %s\n" % (infile), log)
        report("[INFO] Output: %s\n" % (outfile_name), log)
        report("[INFO] Log: %s\n" % (logfile), log)

        f = open(infile)
        line = next(f)
        while line.startswith("##"):
            outfile.write(line)
            line = next(f)
        outfile.write('##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">\n')
        outfile.write('##FORMAT=<ID=QSI,Number=1,Type=Integer,Description="Quality score for any somatic variant, ie. for the ALT haplotype to be present at a significantly different frequency in the tumor and normal">\n')
        header = line
        header = header.replace('NORMAL\t', '')
        header = header.replace('TUMOR', sample_name)
        outfile.write(header)
        indels = Counter()
        for line in f:
            line = line[:-1].split("\t")
            [ref, alt] = line[3:5]
            info = line[7].split(";")
            info = dict([inf.split('=') for inf in info if'=' in inf ])
            qsi = info['QSI']
            sgt = info['SGT'].split('->')[1]
            zygosity = indel2GT(sgt)
            line[8] = "GT:QSI:"+ line[8]
            line[9] = zygosity +":" + qsi + ":" + line[9]
            line[10] = zygosity +":" + qsi + ":" + line[10]
            normal = dict(zip(line[8].split(':'),line[9].split(':')))
            tumor = dict(zip(line[8].split(':'),line[10].split(':')))
            indels['all'] += 1

            
            if fail_filter(normal, tumor):
                indels['fail'] += 1
                continue
            else:
                indels['pass'] += 1
            

            """ Remove normal """
            line[9:] = line[10:]
            outfile.write("\t".join(line)+"\n")


        report('coverage_filter\tnum_indels\tpercent_indels\n', log)
        for k in sorted(indels.keys()):
            report('%s\t%d\t%2.2f%%\n' % (k, indels[k], indels[k]*100./indels['all']), log)
    


