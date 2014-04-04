

stats()
{
    sample=$1
    grep -oP 'set=[^\t]+' /scratch/users/akrishna/melanomics/indels/$sample.combined.vcf|sort | uniq -c | sed -e 's/variant\($\|-\)/dindel\1/g' -e 's/variant2\($\|-\)/gatk\1/g' -e 's/variant3\($\|-\)/varscan\1/g'
}

for k in patient_2 patient_4_NS patient_4_PM patient_6 pool NHEM
do
    echo $k
    stats $k
    echo 
done

