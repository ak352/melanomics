
import os, sys
import collections
from optparse import OptionParser, OptionGroup
sys.path.append("/work/projects/igepilot/tools/pyvcf//dependencies/ordereddict-1.1/install/lib/python2.6/site-packages/")
sys.path.append("/work/projects/igepilot/tools/pyvcf//PyVCF-0.6.0/")
#import vcf

sys.path.append("/home/clusterusers/akrishna/igepilot_users/python/")
sys.path.append("/home/clusterusers/akrishna/igepilot_users/python/class")
#import record, vcf_file
sys.path.append("/work/projects/igepilot/tools/pysam/pysam-0.6//install/lib/python2.6/site-packages")
#import pysam

def vcf_source(vcf_file):
    samtools = False
    gatk = False
    dindel = False
    varscan = False
    caller_found = False
    for line in open(vcf_file):
        if line.startswith("##samtools"):
            caller_found = True
            samtools=True
            return "samtools"
        if line.startswith("##GATKCommandLine"):
            caller_found = True
            gatk=True
            return "gatk"
        if line.startswith("##source=Dindel"):
            caller_found = True
            dindel = True
            return "dindel"
        if line.startswith("##source=VarScan2"):
            caller_found = True
            varscan=True
            return "varscan"

    if not caller_found:
        sys.stderr.write("Every VCF file must have a header line: ##GATKCommandLine, ##source=Dindel or ##source=VarScan2") 
        return "None"

def vcf_sample(vcf_file):
    for line in open(vcf_file):
        if line.startswith("#CHROM"):
            sample_name = line.rstrip("\n").split("\t")[-1]
            return sample_name

#TODO
#def add_variant_quality_to_format_field(vcf_file):
#    for line in open(vcf_file):
#ADD HEADER TOO

def get_coverage(samfile, chr, loc):
    pileup_coverage = {}
    for pileupcolumn in samfile.pileup( chr, loc, loc+1):
        pileup_coverage[pileupcolumn.pos] = pileupcolumn.n

    coverage = pileup_coverage.get(loc, 0)
    return coverage

"""Coverage of an indel  = average coverage of 2 breakpoints"""
def get_coverage_indel(samfile, chr, loc1, loc2):
    return (get_coverage(samfile, chr, loc1) + get_coverage(samfile, chr, loc2))/2

def add_tuple(tuple_instance, value):
    list_tuple = list(tuple_instance)
    list_tuple.append(value)
    return tuple(list_tuple)

def get_breakpoints(str1, str2):
    if len(str1) > len(str2):
        str1, str2 = str2, str1
    (str_a, str_b) = (list(str1), list(str2))

    for x in range(0, len(str)):
        if str_a[x]!=str_b[x]:
            break
    left = x-1
    for x in range(len(str)-1, -1, -1):
        if str_a[x]!=str_b[x]:
            break
    right = x+1

    if left < right:
        return (left, right)
    if left == right:
        return (left, left + 1)
    if left > right:
        return (0, len(str1)+1)
    

def annotate_sample_subfield(sample_name, record, annotation_field, value):
       """Order of values in FORMAT field """
       fields =  record.genotype(sample_name).data._fields
       """Add a new field DP (Not required if 'DP' already in fields)"""
       if annotation_field not in fields:
           fields = add_tuple(fields, annotation_field)
       """Convert the FORMAT field to a dictionary so it can be changed"""
       data_dict = record.genotype(sample_name).data._asdict()
       """Assign depth to DP field"""
       #print data_dict
       data_dict[annotation_field] = value
       #print data_dict
       """Create a new namedtuple"""
       CallData = collections.namedtuple('CallData', fields)
       """Convert data dictionary to a namedtuple of type CallData"""
       CallData = CallData(**data_dict)
       #print "new CallData = ", CallData
       """Modify the record with the new genotype"""
       record.genotype(sample_name).data = CallData
       #print "record.FORMAT = ", record.FORMAT
       """If 'DP' subfield not present in FORMAT, add it"""
       if annotation_field not in record.FORMAT.split(":"):
           record.FORMAT = record.FORMAT + ":" + annotation_field
       #print "record.genotype(sample_name).data = ", record.genotype(sample_name).data
       return record


def get_bam_files(list_of_sample_bam):
    sample_names = []
    bam_files = []
    for line in open(list_of_sample_bam):
        line = rstrip("\n").split("\t")
        sample_names.append(line[0])
        bam_files.append(line[1])
    return (sample_names, bam_files)

def annotate_with_coverage(merged_vcf, nocallref_vcf, sample_name, bam_file):

    samfile = pysam.Samfile(bam_file, "rb")
    vcf_reader = vcf.Reader(open(merged_vcf, "r"))
    vcf_writer = vcf.Writer(open(nocallref_vcf, 'w'), vcf_reader)
    """Coverage is labeled as the DP subfield"""
    annotation_field = "DP"

    """Modify the header to add a DP sub-field to FORMAT field"""
    #print "Header = ", vcf_reader.formats
    assert annotation_field in vcf_reader.formats, (annotation_field, " not in header")
 
    """Check the coverage of each record where the sample has not called a variant"""
    for record in vcf_reader:
        coverage = get_coverage(samfile, record.CHROM, record.POS)
        """Get coverage from BAM file"""
        """If an indel is present, coverage  = average of the start position  and start position+length of the reference allele"""
        """All possible insertions and deletions are within these two points"""
        record = annotate_sample_subfield(sample_name, record, annotation_field, coverage)

        """Need to add this field for all other samples if it is new, as otherwise the output is not a valid SAM file"""
        for sample in record.samples:
            other_sample_name = sample.sample
            "Annotate all other sample names with . if no annotation provided"
            if other_sample_name != sample_name:
                fields =  record.genotype(other_sample_name).data._fields
                if annotation_field not in fields:
                    record = annotate_sample_subfield(other_sample_name, record, annotation_field, None)

        """Write the modified vcf record in the new vcf file"""
        vcf_writer.write_record(record)

#TODO!! PERHAPS instead of marking each site as homozygous reference, it should be marked as no-call (N?) if coverage = 0, otherwise should be left as ./.
def check_if_reference_call(merged_vcf, nocallref_vcf, sample_name, bam_file):
    if options.verbose:
        print "merged vcf file = ", merged_vcf
        print "sample name = ", sample_name
        print "bam file = ", bam_file
    chr = "Chr1"
    loc = 16065
#    loc = 10000

    samfile = pysam.Samfile(bam_file, "rb")
    vcf_reader = vcf.Reader(open(merged_vcf, "r"))
    vcf_writer = vcf.Writer(open(nocallref_vcf, 'w'), vcf_reader)

    """Check the coverage of each record where the sample has not called a variant"""
    for record in vcf_reader:
        if record.genotype(sample_name)['GT']==None:
            """Get coverage from BAM file"""
            coverage = get_coverage(samfile, record.CHROM, record.POS)
            if coverage > 0:
                """Order of values in FORMAT field """
                fields =  record.genotype(sample_name).data._fields
                """Convert the FORMAT field to a dictionary so it can be changed"""
                data_dict = record.genotype(sample_name).data._asdict()
                """Homozygous reference as coverage > 0"""
                data_dict["GT"] = "0/0"
                """Create a new namedtuple"""
                CallData = collections.namedtuple('CallData', fields)
                """Convert data dictionary to a namedtuple of type CallData"""
                CallData = CallData(**data_dict)
                """Modify the record with the new genotype"""
                record.genotype(sample_name).data = CallData

        """Write the modified vcf record in the new vcf file"""
        vcf_writer.write_record(record)

#    for line in open(merged_vcf):
#        if line.startswith("#CHROM"):
#            header = line;
#        if not line.startswith("#"):
#            record = VcfFile.VcfRecord(header, line)
#            if getattr(record, sample_name)=="./.":
#                coverage = get_coverage(samfile, record.CHROM, int(record.POS))
#                print "coverage = ", coverage
#                if coverage > 0:
#                    print line + "0/0"
#                else:
#                    print line + "./."
#            else:
#                print line


#    samfile.close()
        
    

    return
    

            
def filter_and_sort_contigs(vcf_files):

    filtered_vcf_files = []
    for vcf_file in vcf_files:
        filtered_vcf_file = vcf_file.split("/")[-1] + ".filt"
        try:
            new_sample_name = vcf_sample(vcf_file) + "_" + vcf_source(vcf_file).upper()
        except AttributeError:
            print "vcf file = ", vcf_file
            sys.exit()
        if options.verbose:
            print "filtered_vcf_file = ", filtered_vcf_file, " (source: ", vcf_source(vcf_file),")"
            print "(sample name = ", vcf_sample(vcf_file), "), (new sample name = ", new_sample_name, ")"
        os.system("perl vcfsorter.pl " + dictionary + " " + vcf_file + " " + new_sample_name +" > " + filtered_vcf_file)
        filtered_vcf_files.append(filtered_vcf_file)
    return filtered_vcf_files

def filter_contigs_vcf_file(vcf_files):
    filtered_vcf_files = []

    for x in range(0, len(vcf_files)):
        vcf_file = vcf_files[x]
        filtered_vcf_file = vcf_file.split("/")[-1] + ".filt"
        print "filtered_vcf_file = ", filtered_vcf_file
        filtered_vcf_files.append(filtered_vcf_file)

        out = open(filtered_vcf_file, "w+")
        chromosomes = []
        for x in range(1,23):
            chromosomes.append(str(x))
        chromosomes.append("X")
        chromosomes.append("Y")
    
        for line in open(vcf_file):
            if line.startswith("#CHROM"):
                header  = line
                out.write(line)
            elif not line.startswith("#"):
                record = VcfFile.VcfRecord(header, line)
                if record.CHROM.lstrip("Chr") in chromosomes:
                    out.write(line)
                
            else:
                out.write(line)

    return filtered_vcf_files



def combine_variants(vcf_files):
    cmd = java + " -Xmx2g -jar " +gatk_jar+ " -T CombineVariants  "
    for vcf_file in vcf_files:
        print vcf_file
        cmd = cmd + "--variant:VCF " +vcf_file+ " "
    cmd = cmd + "-o " + output_vcf + " "
    cmd = cmd + "-R " + reference + " "
    #cmd = cmd + "-genotypeMergeOptions UNIQUIFY"
    print cmd
    return cmd

def get_vcf_filenames():
    vcf_files = []
    for line in open(options.list_of_vcf):
        vcf_files.append(line.rstrip())
    return vcf_files

def parser():
    parser = OptionParser()

    parser.add_option("-o", "--output", dest="output", type="string", help="merged output VCF file")
    parser.add_option("-c", "--combine", action="store_true", dest="combine", default=False, help="combine VCF files for individual samples")
    group_combine = OptionGroup(parser, "Options for combining VCF files. Only required with -c option")
    group_combine.add_option("-i", "--variants", action="append", dest="vcf_files", type="string", help="VCF files to be combined")
    group_combine.add_option("--list-of-vcf", dest="list_of_vcf", type="string", help="File containing path to VCF files to be combined")
    group_combine.add_option("-g", "--gatk", dest="gatk_jar", type="string", help="absolute location of GATK jar file")
    group_combine.add_option("-r", "--reference", dest="reference", type="string", help="reference genome (FASTA format)")
    group_combine.add_option("-d", "--dict", dest="dict", type="string", help="reference dict file generated by running Picard CreateSequenceDictionary on reference FASTA")
    group_combine.add_option("-v", "--verbose", dest="verbose", action="store_true", default=False, help="verbose")
    parser.add_option_group(group_combine)


    parser.add_option("-n", "--nocallref", action="store_true", dest="nocallref", default=False, help="substitute all no-call genotypes(.) which have non-zero coverage with reference (0)")
    group = OptionGroup(parser, "Options for checking whether no-call is reference. Required with -n.")
    group.add_option("--merged-vcf", dest="merged_vcf", type="string", help="VCF file to be annotated with reference call")
    group.add_option("--sample-name", dest="sample_name", type="string", help="Name of sample in merged vcf file to be annotated with reference call")
    group.add_option("--bam-file", dest="bam_file", type="string", help="absolute location of bam file corresponding to the sample in --sample-name")
    group.add_option("--list-of-bam-files", dest="list_of_sample_bam", type="string", help="File containing sample names and bam files in tab-separated format") 
    parser.add_option_group(group)
    (options, args) = parser.parse_args()
    return (options, args)

if __name__=="__main__":

    (options, args) = parser()

    if options.combine:
        java_home = os.environ['JAVA_HOME']
        if not java_home:
            sys.stderr.write("WARNING: Set $JAVA_HOME in environment so that $JAVA_HOME/bin/ contains the java binary\n")
        java = os.environ['JAVA_HOME'] + "/bin/java"
        reference = options.reference
        gatk_jar = options.gatk_jar
        output_vcf = options.output
        dictionary = options.dict
    
        """Get VCF files from commandline or file"""
        if options.vcf_files:
            vcf_files = options.vcf_files
        else:
            vcf_files = get_vcf_filenames()

        if options.verbose:
            print "options.vcf_files = ", vcf_files
            
        filtered_vcf_files = filter_and_sort_contigs(vcf_files)#filter_contigs_vcf_file(options.vcf_files)
        if options.verbose:
            print "filtered_vcf_files = ", filtered_vcf_files
        os.system(combine_variants(filtered_vcf_files))

    if options.nocallref:
        #check_if_reference_call(options.merged_vcf, options.output, options.sample_name, options.bam_file)
        annotate_with_coverage(options.merged_vcf, options.output, options.sample_name, options.bam_file)    

        
