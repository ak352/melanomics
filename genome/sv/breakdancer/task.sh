#!/bin/bash --login
cat samples | parallel --colsep ' ' ./run_breakdancer.sh

