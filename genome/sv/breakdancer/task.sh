#!/bin/bash --login
cat samples | parallel -u --colsep ' ' ./run_breakdancer.sh

