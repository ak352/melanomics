import sys
import vcf_file

x = vcf_file.VcfFile(sys.argv[1])
x.to_masterfile(sys.argv[2], ref_threshold=5)
