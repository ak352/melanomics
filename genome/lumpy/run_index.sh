#!/bin/bash --login


YAHA="/work/projects/melanomics/tools/yaha/yaha"
ref=$1


echo "Run index"
date
CMD="${YAHA} -g ${ref} -L 11"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Indexing finished."
