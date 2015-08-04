#!/bin/bash

########################################################
# Version 25.03.2014
# - change dbsnp version 137 to  138
# - change cosmic verstion 67 to 68 
# - add cosmic version 68 wgs
# - add clinVar version 20140211
# - change from ljb2 to ljb23 with new scores
# - add cadd scores direct from ANNOVAR (>20, 1% percentile)
# - add Complete Genomics dataset cg46

projectdir=/mnt/nfs/projects/isbsequencing
toolsdir=$projectdir/tools
cgatools=$toolsdir/cgatools/bin/cgatools

annovardir=$projectdir/scripts/ANNOVAR
commonvariants=$projectdir/data/commonvariantblocks.tsv
annovar=$annovardir/annovar/annotate_variation.pl
annovartable=$annovardir/annovar/table_annovar.pl
convert2annovar=$projectdir/scripts/snps/pipeline/convertList2Annovar.pl
convertAnnovar2list=$projectdir/scripts/pipeline/convertAnnovarMultianno2CGI.pl
humandb=$annovardir/humandb
buildver=hg19

tested=$1
echo $tested
input=$tested.annovar.input

# convert to ANNOVAR format
perl $convert2annovar $tested >$input

# run various annotation databases
perl $annovardir/annovar/table_annovar.pl $input $annovardir/humandb -buildver $buildver -protocol refGene,ensGene,knownGene,ccdsGene,wgEncodeGencodeManualV4 -operation g,g,g,g,g -outfile $input.geneanno 2>annovar.geneanno.log

perl $annovardir/annovar/table_annovar.pl $input $annovardir/humandb -buildver $buildver -protocol esp6500si_all,esp6500si_ea,cg46,cg69,1000g2012apr_all,1000g2012apr_eur -operation f,f,f,f,f,f -outfile $input.maf 2>annovar.maf.log 

perl $annovardir/annovar/table_annovar.pl $input $annovardir/humandb -buildver $buildver -protocol phastConsElements46way,segdup,cytoband,dgv,tfbs,gwascatalog,wgEncodeRegTfbsClustered,wgEncodeRegDnaseClustered,mirna,mirnatarget -operation r,r,r,r,r,r,r,r,r,r  -outfile $input.regions 2>annovar.regions.log 

perl $annovardir/annovar/table_annovar.pl $input $annovardir/humandb -buildver $buildver -protocol snp138,cosmic68,cosmic68wgs,nci60 -operation f,f,f,f -outfile $input.dbsnpcosmicanno 2>annovar.dbsnpcosmic.log

perl $annovardir/annovar/table_annovar.pl $input $annovardir/humandb -buildver $buildver -protocol ljb23_all,caddgt20,clinvar_20140211 -operation f,f,f -outfile $input.genescores 2>annovar.genescores.log

# add annotation to testvariantfile

cur=$tested
add=$input.dbsnpcosmicanno.${buildver}_multianno.txt
out=$tested.cosmic.dbsnp.nci60

perl $convertAnnovar2list $add >$add.cgi
$cgatools join --beta --input $cur $add.cgi --output $out --match chromosome:Chr --match begin:Start --match end:End --match alleleSeq:Alt --select 'a.*,b.snp138,b.cosmic68,b.cosmic68wgs,b.nci60' --output-mode compact --always-dump

cur=$out
add=$input.maf.${buildver}_multianno.txt
out=$cur.maf

perl $convertAnnovar2list $add >$add.cgi
$cgatools join --beta --input $cur $add.cgi --output $out --match chromosome:Chr --match begin:Start --match end:End --match alleleSeq:Alt --select 'a.*,b.esp6500si_all,b.esp6500si_ea,b.cg46,cg69,b.1000g2012apr_all,b.1000g2012apr_eur' --output-mode compact --always-dump

cur=$out
add=$input.geneanno.${buildver}_multianno.txt
out=$cur.geneanno

perl $convertAnnovar2list $add >$add.cgi
$cgatools join --beta --input $cur $add.cgi --output $out --match chromosome:Chr --match begin:Start --match end:End --match alleleSeq:Alt --output-mode compact --always-dump --select 'a.*,b.Func.refGene,b.Gene.refGene,b.ExonicFunc.refGene,b.AAChange.refGene,b.Func.ensGene,b.Gene.ensGene,b.ExonicFunc.ensGene,b.AAChange.ensGene,b.Func.knownGene,b.Gene.knownGene,b.ExonicFunc.knownGene,b.AAChange.knownGene,b.Func.ccdsGene,b.Gene.ccdsGene,b.ExonicFunc.ccdsGene,b.AAChange.ccdsGene,b.Func.wgEncodeGencodeManualV4,b.Gene.wgEncodeGencodeManualV4,b.ExonicFunc.wgEncodeGencodeManualV4,b.AAChange.wgEncodeGencodeManualV4'

cur=$out
add=$input.genescores.${buildver}_multianno.txt
out=$cur.genescores

perl $convertAnnovar2list $add >$add.cgi
$cgatools join --beta --input $cur $add.cgi --output $out --match chromosome:Chr --match begin:Start --match end:End --match alleleSeq:Alt --output-mode compact --always-dump --select 'a.*,b.LJB23_SIFT_score,b.LJB23_SIFT_score_converted,b.LJB23_SIFT_pred,b.LJB23_Polyphen2_HDIV_score,b.LJB23_Polyphen2_HDIV_pred,b.LJB23_Polyphen2_HVAR_score,b.LJB23_Polyphen2_HVAR_pred,b.LJB23_LRT_score,b.LJB23_LRT_score_converted,b.LJB23_LRT_pred,b.LJB23_MutationTaster_score,b.LJB23_MutationTaster_score_converted,b.LJB23_MutationTaster_pred,b.LJB23_MutationAssessor_score,b.LJB23_MutationAssessor_score_converted,b.LJB23_MutationAssessor_pred,b.LJB23_FATHMM_score,b.LJB23_FATHMM_score_converted,b.LJB23_FATHMM_pred,b.LJB23_RadialSVM_score,b.LJB23_RadialSVM_score_converted,b.LJB23_RadialSVM_pred,b.LJB23_LR_score,b.LJB23_LR_pred,b.LJB23_GERP++,b.LJB23_PhyloP,b.LJB23_SiPhy,b.caddgt20,b.clinvar_20140211'

cur=$out
add=$input.regions.${buildver}_multianno.txt
out=$cur.regions

perl $convertAnnovar2list $add >$add.cgi
$cgatools join --beta --input $cur $add.cgi --output $out --match chromosome:Chr --match begin:Start --match end:End --match alleleSeq:Alt --output-mode compact --always-dump --select 'a.*,b.phastConsElements46way,b.segdup,b.cytoBand,b.dgv,b.tfbs,b.gwascatalog,b.wgEncodeRegTfbsClustered,b.wgEncodeRegDnaseClustered,b.mirna,b.mirnatarget'

add=/work/projects/isbsequencing/data/clinvar/clinvar_current.vcf.annovar.list
cur=$out
$cgatools join --beta --input $cur $add --output $cur.clinVar --match chromosome:chr --match begin:start --match end:stop --match alleleSeq:var --output-mode compact --always-dump --select 'a.*,b.clinVar'

#cur=$cur.clinVar
add=/work/projects/isbsequencing/tools/GWAVA/VEP_plugin/gwava_scores.tsv
$cgatools join --beta --input $cur $add --output $cur.gwava --match chromosome:chr --match begin:start --match end:stop --output-mode compact --always-dump --select 'a.*,b.gwava_reg,b.gwava_tss,b.gwava_unm'

cur=$cur.gwava
add=/work/projects/isbsequencing/data/CADD/cadd.tsv
$cgatools join --beta --input $cur $add --output $cur.cadd --match chromosome:chr --match end:pos --match alleleSeq:alt --output-mode compact --always-dump --select 'a.*,b.CADD_RawScore,b.CADD_PHRED'

cur=$cur.cadd
addGeneScores=/mnt/nfs/projects/isbsequencing/scripts/snps/addGeneScores.pl
add=$tested.genescores.txt
perl $addGeneScores $input.geneanno.${buildver}_multianno.txt >$add
perl $convertAnnovar2list $add >$add.cgi
$cgatools join --beta --input $cur $add.cgi --output $cur.genescores --match chromosome:Chr --match begin:Start --match end:End --match alleleSeq:Alt --output-mode compact --always-dump --select 'a.*,b.RVIS,b.RVISpercent,b.CMD,b.BODYMAP_BRAIN,b.PATHOSCORE,b.HAPLOINSUFF,b.CGD,b.CGD_NEURO'



