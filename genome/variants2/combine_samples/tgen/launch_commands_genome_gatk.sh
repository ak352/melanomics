#!/bin/bash


oarsub -lcore=12/nodes=1,walltime=24 -n combine_tgen ./commands_genome_gatk3.sh

