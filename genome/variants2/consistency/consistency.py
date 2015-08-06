import pysam
import re
import sys
import copy 

def RemoveIndels(string):
    string = list(string)
    new_seq = ""
    indel = ""
    is_indel = False
    has_length = False
    for c in range(len(string)):
        char = string[c]
        if char=="+" or char=="-" or is_indel:
            is_indel = True
            if not char.isdigit() and not char in ["+","-"]:
                #print "indel = ", indel
                if not has_length:
                    if len(indel)==1:
                        length = 1
                    else:
                        length = float(indel[1:])
                    has_length = True
                    curr_length = 0
                indel += char
                curr_length += 1
                if curr_length == length:
                    #print "Indel = ", indel, length
                    indel = ""
                    has_length = False
                    is_indel = False

                    
            else:
                indel += char
        if not is_indel and char not in "$*":
            new_seq += char
    new_seq = re.sub("\^.","", new_seq) 
        
    #print new_seq
    return new_seq

def GetCoverages(line, normal, tumor):
    [chrom, start, end] = line[1:4]
    counts = {}
    for p in pysam.mpileup("-r %s:%s-%s" % (chrom, str(int(start)+1), end), normal): #, chrom, start, end)
        seq = p.split("\t")[4].upper()
        #print seq
        bases = RemoveIndels(seq)
        for base in bases:
            if base not in counts:
                counts[base] = 0
            counts[base] += 1
        print counts

    return (0,0)

def LoadCoveragesSomatic(fasd_somatic_file):
    sys.stderr.write("[INFO] Loading fasd somatic file...\n")
    sys.stderr.write("[INFO] somatic file = %s...\n" % (fasd_somatic_file))
    somatic = {}
    for line in open(fasd_somatic_file):
        line = line[:-1].split("\t")
        somatic[tuple(line[0:2])] = [line[4], line[6], line[7]]
    sys.stderr.write("[INFO] done.\n")
    return somatic
#Converts "A:10,A:5" to A:15
def AddUp(string):
    string = string.split(",")
    for x in range(len(string)):
        string[x] = string[x].split(":")
    summ = []
    counts = []
    for k in range(len(string)/2):
        counts.append(int(string[2*k][1])+int(string[2*k+1][1]))
        summ.append(string[2*k][0] +":"+ str(int(string[2*k][1])+int(string[2*k+1][1])))
    summ = ",".join(summ)
    if len(counts)==2:
        ratio = float(counts[0])/float(counts[1]+counts[0])
    else:
        ratio = 1
    return summ, str(ratio)


    

def GetCoveragesSomatic(line, somatic_map):
    [chrom, start, end] = line[1:4]
    
    normal, tumor, score = [s.upper() for s in somatic_map.get((chrom, end), ["-1", "-1", "-1"])]
    #print normal, tumor
    normal, tumor = [AddUp(s) for s in [normal, tumor]]
    return normal, tumor, score


if __name__ == "__main__":
    params = open("input", "r")
    num_inputs = params.readline()[:-1]
    if num_inputs.isdigit():
        num_inputs = int(num_inputs)
    else:
        sys.stderr.write("First line of input file must be a whole number.")
        sys.exit()
    for x in range(num_inputs):
        infile = params.readline()[:-1]
        tumour_bam = params.readline()[:-1]
        normal_bam = params.readline()[:-1]
        fasd_somatic_file = params.readline()[:-1]
        output_file = params.readline()[:-1]
        log_file = params.readline()[:-1]
        somatic_map = LoadCoveragesSomatic(fasd_somatic_file)
        logfile = open(log_file, "w+")
        ofile = open(output_file, "w+")

        
        #Summary stats
        num_consistent = 0
        num_inconsistent = 0
        total = 0

        for line in open(infile):
            line = line[:-1].split("\t")
            counts = [0]*2
            start_col = 8
            anno = []
            for k in range(start_col,len(line)):
                nucs = list(line[k])
                for nuc in nucs:
                    if nuc=="1":
                        counts[k-start_col]+=1
            if counts[0] > counts[1]:
                #print "\t".join(line)
                #cov_normal, cov_tumour = GetCoverages(line, normal_bam, tumour_bam)
                anno.append("inconsistent")
                num_inconsistent += 1
            else:
                anno.append("")
                num_consistent += 1
            cov_normal, cov_tumour, score = GetCoveragesSomatic(line, somatic_map)
            anno.extend([cov_normal[0], cov_tumour[0], cov_normal[1], cov_tumour[1], score])
            line.extend(anno)
            total += 1
            ofile.write("\t".join(line)+"\n")
        
        #Report summary stats
            
        sys.stderr.write("[INFO] Total number of variants = %s\n" % (total))
        sys.stderr.write("[INFO] Number consistent = %s (%s %%)\n" % (num_consistent, float(num_consistent)/float(total)))
        sys.stderr.write("[INFO] Number inconsistent = %s (%s %%)\n" % (num_inconsistent, float(num_inconsistent)/float(total)))
        logfile.write("[INFO] Total number of variants = %s\n" % (total))
        logfile.write("[INFO] Number consistent = %s (%s %%)\n" % (num_consistent, float(num_consistent)/float(total)))
        logfile.write("[INFO] Number inconsistent = %s (%s %%)\n" % (num_inconsistent, float(num_inconsistent)/float(total)))

        #TODO: Use samtools or PyVCF to get the number of different allele calls from the respective BAM files
        #TODO: Get the statistics of the relative counts of nucleotides
            #TODO: Get the statistics of the average mapping qualities of the alleles called in the tumour genome 
            #print counts

    
