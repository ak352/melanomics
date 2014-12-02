while read line
do
    grep -v '^#' $line | wc -l
done < count_input > count_output

    