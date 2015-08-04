import os
import sys
from optparse import OptionParser
from subprocess import Popen, PIPE
from dindel import *
from oar import oarsub_cmd


"""Tool for SNP calling"""
def samtools(bamfile, reference, tools_dir):
    
    """Strip location so that output is in the current directory"""
    bamfile_without_path  = str(bamfile).split("/")[-1]

    list_cmd = []
    list_cmd.append(tools_dir + '/samtools/samtools mpileup -ugf ' + str(reference) +' '+ str(bamfile) +'  > '+ bamfile_without_path + '.samtools.pileup')
    list_cmd.append(tools_dir + '/samtools/bcftools/bcftools view -vcg '+ bamfile_without_path +'.samtools.pileup > ' + bamfile_without_path +'.samtools.vcf')
    
    
    oarsub_command = oarsub_cmd(list_cmd, 72, 2)
    return oarsub_command

def create_gatk_reference(reference, tools_dir, gatk_reference):
    if option.verbose:
        print "Creating reference for GATK..."
    for k in range(1,23):
        os.system(tools_dir+'/samtools/samtools faidx '+ reference +' Chr'+str(k)+' >> ' + gatk_reference)
    os.system(tools_dir+'/samtools/samtools faidx '+ reference +' ChrX >> ' + gatk_reference)
    os.system(tools_dir+'/samtools/samtools faidx '+ reference +' ChrY >> ' + gatk_reference)

"""Check if the file exists and has nonzero size"""
def file_exists_with_nonzero_size(filename):
    try:
        with open(filename) as f: 
            stats = os.stat(filename)
            if int(stats.st_size)==0:
                return False
            else:
                return True
    except IOError as e:
        return False


def create_gatk_reference_index(tools_dir, gatk_reference):
    os.system(tools_dir + '/samtools/samtools index ' + gatk_reference)

def create_gatk_reference_dict(tools_dir, gatk_reference, dict_file):
    os.system('rm -rf ' + dict_file)
    os.system(java + ' -jar  /home/clusterusers/akrishna/tools/picard/trunk/dist/CreateSequenceDictionary.jar REFERENCE='+gatk_reference+' OUTPUT='+dict_file)

"""Prepare new reference file as GATK requires only chromosomes which are present in BAM files""" 
def prepare_gatk_reference(reference, tools_dir, gatk_reference):
    assert gatk_reference.endswith(".fa"), "GATK reference file should end with .fa"

    """GATK reference"""
    if file_exists_with_nonzero_size(gatk_reference):
        if option.verbose:
            print "GATK reference file", gatk_reference, "present."
    else:
        if option.verbose:
            print "No GATK reference file", gatk_reference
        create_gatk_reference(reference, tools_dir, gatk_reference)

    """GATK reference index"""
    if file_exists_with_nonzero_size(gatk_reference + ".fai"):
        if option.verbose:
            print "GATK reference file index present."
    else:
        if option.verbose:
            print "No GATK reference file index."
        create_gatk_reference_index(tools_dir, gatk_reference)
    
    """GATK reference dict"""
    dict_file = gatk_reference.rstrip(".fa") + ".dict"
    if file_exists_with_nonzero_size(dict_file):
        if option.verbose:
            print "Dict present"
    else:
        if option.verbose:
            print "Dict absent"
        create_gatk_reference_dict(tools_dir, gatk_reference, dict_file)
    

"""GATK SNP calling"""
def gatk_unified_genotyper(bamfile, gatk_reference, tools_dir, java):
    """Strip location so that output is in the current directory"""
    bamfile_without_path  = str(bamfile).split("/")[-1]
    cmd_list = []
    cmd_list.append(java + ' -jar ' + tools_dir + '/gatk/GenomeAnalysisTKLite-2.1-12-g2d7797a/GenomeAnalysisTKLite.jar -T UnifiedGenotyper '+ 
                    '-glm BOTH ' +
                    '-A DepthOfCoverage '+
                    '-A AlleleBalance '+
                    '-dcov 200 ' +
                    '-R ' + gatk_reference + 
                    ' -o '+bamfile_without_path+'.gatk.variants.vcf '+
                    '--output_mode EMIT_VARIANTS_ONLY ' + 
                    '-I ' + bamfile)
    oarsub_command = oarsub_cmd(cmd_list, 72,2)
    
    return oarsub_command

"""SNP calling - all sites (reference and snps) in the output"""
def gatk_unified_genotyper_all_sites(bamfile, gatk_reference, tools_dir, java):
    """Strip location so that output is in the current directory"""
    bamfile_without_path  = str(bamfile).split("/")[-1]
    cmd_list = []
    cmd_list.append(java + ' -jar ' + tools_dir + '/gatk/GenomeAnalysisTKLite-2.1-12-g2d7797a/GenomeAnalysisTKLite.jar -T UnifiedGenotyper '+
                    '-R ' + gatk_reference +
                    ' -o '+bamfile_without_path+'.gatk.vcf '+
                    '--output_mode EMIT_ALL_SITES ' +
                    '-I ' + bamfile)
    oarsub_command = oarsub_cmd(cmd_list, 72,2)

    return oarsub_command

    


"""Get BAM file names from an input file"""
def get_bam_files(filename):
    bamfiles = []
    for line in open(filename):
        bamfiles.append(line.rstrip())
    return bamfiles

"""Index all bamfiles"""
def samtools_index(bamfiles):
    for bamfile in bamfiles:
        list_cmd = []
        list_cmd.append(tools_dir + '/samtools/samtools index '+bamfile)
        print oarsub_cmd(list_cmd, 72, 2)
        os.system(oarsub_cmd(list_cmd, 72, 2))



"""Command-line options parser"""
def prepare_parser():
    parser = OptionParser()
    parser.add_option("-i", "--input", dest="bamfiles", default="bamfiles.in",
                      help="list of input bam files with path")
    parser.add_option("-r", "--reference", dest="reference", default="../reference/hg19.chr.fa",
                      help="list of input bam files with path")
    parser.add_option("-s", "--samtools", dest="samtools", action="store_true", default=False,
                      help="perform samtools snp calling")
    parser.add_option("-v", "--verbose", dest="verbose", action="store_true", default=False,
                      help="verbose")
    parser.add_option("-x", "--samtools-index", dest="sam_index", action="store_true", default=False,
                      help="index BAM files using samtools")
    parser.add_option("-d", "--dindel", dest="dindel", action="store_true", default=False,
                      help="call indels using dindel")
    parser.add_option("--dindel2", dest="dindel2", action="store_true", default=False,
                      help="execute dindel stage 3")
    parser.add_option("--dindel3", dest="dindel3", action="store_true", default=False,
                      help="execute dindel stage 3")
    parser.add_option("--dindel3-files-per-node", dest="number_of_files_per_node",
                      help="increase number of files per node to decrease parallelization")
    parser.add_option("--dindel4", dest="dindel4", action="store_true", default=False,
                      help="execute dindel stage 4")
    parser.add_option("--dindel5", dest="dindel5", action="store_true", default=False,
                      help="execute dindel stage 5")

    parser.add_option("--gatk-reference", dest="gatk_reference", action="store_true", default=False,
                      help="create reference files for GATK")
    parser.add_option("-g", "--gatk", dest="gatk", action="store_true", default=False,
                      help="execute GATK UnifiedGenotyper analysis")
    parser.add_option("--temp", dest="temp", default="",
                      help="temporary folder to save intermediate files") 
    (option, args) = parser.parse_args()
    return (option, parser)

if __name__=="__main__":
    tools_dir = '/work/projects/isbsequencing/tools/'
    java = '/usr/bin/java'
    gatk_reference = 'hg19.Chr.gatk.fa'

    (option, parser) = prepare_parser()

    """Get list of BAM files in the folder given as 1st command line argument"""
    bamfiles = get_bam_files(option.bamfiles)
    """Reference is given as 2nd command line argument"""
    reference = option.reference
    """Index BAM files"""
    if option.sam_index:
        samtools_index(bamfiles)


    """Get variants for all BAM files"""

    """Use samtools"""
    if option.samtools:
        if option.verbose:
            print "Using samtools..."
        for bamfile in bamfiles:
            os.system(samtools(bamfile, reference, tools_dir))
            if option.verbose:
                print "Starting job running samtools on ", bamfile 
        
    """Use dindel"""
    if option.dindel:
        prepare_dindel_directories(option)
        for bamfile in bamfiles:
            print dindel(bamfile, reference, tools_dir, option)
            """os.system(dindel(bamfile, reference, tools_dir))"""
            """job_details = os.system(dindel_stage_2(bamfile, reference, tools_dir))"""

    if option.dindel2:
        for bamfile in bamfiles:
            job_details = os.system(dindel_stage_2(bamfile, reference, tools_dir, option))

    if option.dindel3:
        if option.verbose:
            print "Option for Dindel stage 3 chosen..."
        for bamfile in bamfiles:
            if option.number_of_files_per_node:
                dindel_stage_3(bamfile, reference, tools_dir, int(option.number_of_files_per_node), option)#os.system(dindel_stage_3(bamfile, reference, tools_dir, int(option.number_of_files_per_node), option))
            else:
                parser.error("Need argument --dindel3-files-per-node.")
            
    if option.dindel4:
        for bamfile in bamfiles:
            os.system(dindel_stage_4(bamfile, reference, tools_dir, option))


    """Use GATK"""
    if option.gatk_reference:
        prepare_gatk_reference(reference, tools_dir, gatk_reference)
    if option.gatk:
        for bamfile in bamfiles:
            os.system(gatk_unified_genotyper(bamfile, option.reference, tools_dir, java))
