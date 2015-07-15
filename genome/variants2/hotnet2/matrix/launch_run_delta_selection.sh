

OUTDIR=/work/projects/melanomics/analysis/genome/variants2/hotnet/mutations/delta
mkdir -v $OUTDIR
name=hotnet_delta_select
stderr=$OUTDIR/delta_selection.stderr
stdout=$OUTDIR/delta_selection.stdout
oarsub -t bigmem -lcore=12,walltime=120 -O $stdout -E $stderr -n $name ./run_delta_selection.sh
