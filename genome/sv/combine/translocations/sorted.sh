


input=$1
head -n1 $input;
sed '1d' $input \
| awk -F"\t" 'BEGIN{OFS="\t"}{print $5,$6,$7,$8,$0;}' \
| sed 's/^\([0-9]\t\)/0\1/g' \
| sed 's/^\([0-9]\+\t\)\([0-9]\t\)/\10\2/g' \
| sort -k1,2 -k3,4n \
| sed 's/^0//g' \
| sed 's/^\([^\t]\+\t\)0/\1/g' \
| cut -f5-;



