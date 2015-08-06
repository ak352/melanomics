

while read line
do
    set $line
    vcf=$2
    vcf=${vcf%.sorted}
    (grep ^"#" $vcf; \
	for k in {1..22}
	do
	    grep -P ^"${k}\t" $vcf;
	done; \
	    grep -P ^"X\t" $vcf; \
	    grep -P ^"MT\t" $vcf;) | sed 's/;\t/\t/g' > $vcf.sorted
done < vcf_files.in



