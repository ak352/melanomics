#Trim input info
ls /work/projects/melanomics/analysis/genome/*/fastqc/*fastqc | grep -oP '(patient|NHEM).+' | sed 's/[0-9]\.ft\.R[1-2]_[1-2]_fastqc://g'| sort -u | sed 's/.\+/&\n&*/g' | sed 's/fastqc[^\*]\+\*/trim/g' > fastqc_files

