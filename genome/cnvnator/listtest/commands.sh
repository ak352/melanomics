prepare()
{
    for k in 2 4 5 6 7 8; do for m in PM NS; do cut -f2,4  /work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_${k}_${m}.cnv| sed 's/:/\t/1' | sed 's/-/\t/1' | sed '1,3d' | head -n -2 > /work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_${k}_${m}.cnv.1; done; done
}


list()
{

    python ListCNVDetails.py

}

tested()
{
    for k in 2 4 5 6 7 8
    do
	list_file=/work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_${k}.cnv.list
	cnv1=/work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_${k}_NS.cnv.1
	cnv2=/work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_${k}_PM.cnv.1
	tested1=/work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_${k}.cnv.list.NS.tested
	tested2=/work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_${k}.cnv.list.PM.tested
	tested=/work/projects/melanomics/analysis/genome/cnvnator/binSize100/patient_${k}.cnv.list.NS.PM.tested
	echo Testing NS..
	python TestCNVDetails.py  $list_file $cnv1 > $tested1
	echo Testing PM...
	python TestCNVDetails.py $list_file $cnv2 > $tested2
	paste <( cat $tested1) <( cut -f4 $tested2) | sed 's/NA/1/g' \
	    | sed 's/^chr\([0-9]\t\)/chr0\1/g' | sort -k1,1 -k2,3n \
	    | sed 's/^chr0/chr/g' > $tested

	echo Output written to $tested
    done
    
     

}


#prepare
#list
tested
