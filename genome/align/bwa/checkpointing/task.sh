#!/bin/bash --login
cat bam_files | parallel -k --colsep ' ' ../flagstats.sh

