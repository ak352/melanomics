

# python generateHeat.py mutsig <additional_parameters>
# 
# =============================================================================================================
# | PARAMETER NAME          | REQUIRED/DEFAULT   | DESCRIPTION                                                |
# =============================================================================================================
# |--mutsig_score_file      | REQUIRED           |MutSig score file (gene to q-value).                        |
# -------------------------------------------------------------------------------------------------------------
# |--threshold              | 1.0                |Maximum q-value threshold.                                  |
# -------------------------------------------------------------------------------------------------------------
# |--gene_filter_file       | None               |File listing genes whose heat scores should be preserved.   |
# |                         |                    |If present, all other heat scores will be discarded.        |
# -------------------------------------------------------------------------------------------------------------
# |-o/--output_file         | None               |Output file. If none given, output will be written to       |
# |                         |                    |stdout.                                                     |

echo OAR_JOB_ID = $OAR_JOB_ID
curr_dir=$PWD
work_dir=/work/projects/melanomics/tools/hotnet/hotnet2_mutsigpval/

OUTDIR=/work/projects/melanomics/analysis/genome/variants2/hotnet/
mkdir -v $OUTDIR

output=$OUTDIR/mutation.blacklist.out

config_dir=$OUTDIR/config
mkdir -v $config_dir
config=$config_dir/heat_mutation.config


echo Input: $mutsig_file
echo Output: $output



(echo "mutation"; \
 echo "--snv_file /work/projects/melanomics/analysis/genome/variants2/hotnet/mutations/snv.blacklist_filt"; \
 echo "--cna_file /work/projects/melanomics/analysis/genome/variants2/hotnet/mutations/cnv"; \
 echo "--min_freq 1"; \
 echo "--sample_file /scratch/users/akrishna/hotnet2/iref/visualisation/mutation/samples_file"; \
 echo "--output_file $output"; ) > $config


cmd="python $work_dir/generateHeat.py @$config"
echo $cmd
echo Config:
cat $config

eval $cmd



