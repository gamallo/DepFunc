#!/bin/bash

LING=$1
MODELS="./models"
MODELS_GR="./models/citius-$LING"
PROGS="./scripts"
TEST_GR="./tests/citius-$LING"
OUT_GR="./out/citius-$LING"
EVAL="./eval"
SIM="./simil/citius-$LING"
RESULTS="./eval/results"
DEP="./dep/citius-$LING"

echo "building temporary resources"
#zcat $MODELS/freq_filtrado_wiki-${LING}_N.txt.gz |$PROGS/dephead.perl $TEST_GR/sv.txt "down" "Subj" > $DEP/subj_down.txt
#zcat $MODELS/freq_filtrado_wiki-${LING}_V.txt.gz  |$PROGS/dephead.perl $TEST_GR/sv.txt "up" "Subj"  > $DEP/subj_up.txt
#zcat $MODELS/freq_filtrado_wiki-${LING}_V.txt.gz |$PROGS/headdep.perl $TEST_GR/vo.txt "up" "Dobj" > $DEP/dobj_up.txt
#zcat $MODELS/freq_filtrado_wiki-${LING}_N.txt.gz  |$PROGS/headdep.perl  $TEST_GR/vo.txt "down" "Dobj" > $DEP/dobj_down.txt

echo "Starting compositional process..."
echo "building NV_head"
zcat $MODELS/freq_filtrado_wiki-${LING}_V.txt.gz  |$PROGS/nv_head_2.perl  $DEP/subj_up.txt $TEST_GR/sv.txt  $TEST_GR/sv.txt |$PROGS/ranking_freq.perl > $MODELS_GR/NV_head
echo "NV-N_head"
zcat $MODELS/freq_filtrado_wiki-${LING}_V.txt.gz  |$PROGS/nv-n_head.perl  $DEP/dobj_up.txt  $TEST_GR/svo.txt   $MODELS_GR/NV_head  |$PROGS/ranking_freq.perl > $MODELS_GR/NV-N_head

echo "building NV-N_dep"
echo "NV-N_dep"
##para provar com dous tipos de composicionalidade nas restriçoes do dependente:
##com composicionalidade restritiva em dous passos:
zcat $MODELS/freq_filtrado_wiki-${LING}_N.txt.gz  |$PROGS/nv_dep_2.perl  $DEP/subj_down.txt $TEST_GR/sv.txt $TEST_GR/sv.txt  |$PROGS/ranking_freq.perl > $MODELS_GR/NV_dep
zcat $MODELS/freq_filtrado_wiki-${LING}_N.txt.gz  |$PROGS/nv-n_dep_2.perl  $DEP/dobj_down.txt  $TEST_GR/svo.txt   $MODELS_GR/NV_dep  |$PROGS/ranking_freq.perl > $MODELS_GR/NV-N_dep

echo "End left-to-right compositional process"
echo "All compositional models are in ./models/citius-$LING"
echo ""

###############################
##finishing left-to-right, begining right-to-left
###############################
echo "building N-VN_head"
#echo "VN_head"
zcat $MODELS/freq_filtrado_wiki-${LING}_V.txt.gz  |$PROGS/vn_head.perl $DEP/dobj_up.txt $TEST_GR/vo.txt  $TEST_GR/vo.txt |$PROGS/ranking_freq.perl > $MODELS_GR/VN_head

echo "N-VN_head"
zcat $MODELS/freq_filtrado_wiki-${LING}_V.txt.gz  |$PROGS/n-vn_head.perl  $DEP/subj_up.txt  $TEST_GR/svo.txt   $MODELS_GR/VN_head  |$PROGS/ranking_freq.perl > $MODELS_GR/N-VN_head


echo "building N-VN_dep"
echo "N-VN_dep"
##para provar com dous tipos de composicionalidade nas restriçoes do dependente:
##com composicionalidade restritiva em dous passos:
zcat $MODELS/freq_filtrado_wiki-${LING}_N.txt.gz  |$PROGS/vn_dep_2.perl  $DEP/dobj_down.txt $TEST_GR/vo.txt $TEST_GR/vo.txt  |$PROGS/ranking_freq.perl > $MODELS_GR/VN_dep
zcat $MODELS/freq_filtrado_wiki-${LING}_N.txt.gz  |$PROGS/n-vn_dep_2.perl  $DEP/subj_down.txt  $TEST_GR/svo.txt   $MODELS_GR/VN_dep  |$PROGS/ranking_freq.perl > $MODELS_GR/N-VN_dep

##Com composicionalidade 2 (usando dados externos):
#zcat $MODELS/freq_filtrado_wikibnc-en_N.txt.gz |$PROGS/n-vn_dep.perl  $DEP/subj_down.txt  $TEST_GR/svo.txt  $TEST_GR/n-vn.txt |$PROGS/ranking_freq.perl > $MODELS_GR/N-VN_dep

echo "End right-to-left compositional process"
echo "All compositional models are in ./models/citius-$LING/"
echo ""
###############################
##finishing compositional, begining similarity
###############################
echo "Starting similarity computation..."
TH=5
echo "simil: NV-N_head"
PREFIX="NV-N_head"
MODELFILE=$MODELS_GR"/"${PREFIX}
cat $TEST_GR/pairs-svo.txt | $PROGS/measures_th.perl $MODELFILE $TH |
awk '{print $1, $2, $3}' > $OUT_GR/simil_${PREFIX} ;
cat $OUT_GR/simil_${PREFIX} |$EVAL/gold_mean.perl  $TEST_GR/golden-${LING}_svo.txt > $SIM/nv-n_head

echo "simil: NV-N_dep"
PREFIX="NV-N_dep"
MODELFILE=$MODELS_GR"/"${PREFIX}
cat $TEST_GR/pairs-svo.txt | $PROGS/measures_th.perl $MODELFILE $TH |
awk '{print $1, $2, $3}' > $OUT_GR/simil_${PREFIX} ;
cat $OUT_GR/simil_${PREFIX} |$EVAL/gold_mean.perl  $TEST_GR/golden-${LING}_svo.txt > $SIM/nv-n_dep

echo "simil: N-VN_head"
PREFIX="N-VN_head"
MODELFILE=$MODELS_GR"/"${PREFIX}
cat $TEST_GR/pairs-svo.txt | $PROGS/measures_th.perl $MODELFILE  $TH |
awk '{print $1, $2, $3}' > $OUT_GR/simil_${PREFIX} ;
cat $OUT_GR/simil_${PREFIX} |$EVAL/gold_mean.perl  $TEST_GR/golden-${LING}_svo.txt > $SIM/n-vn_head

echo "simil: N-VN_dep"
PREFIX="N-VN_dep"
MODELFILE=$MODELS_GR"/"${PREFIX}
cat $TEST_GR/pairs-svo.txt | $PROGS/measures_th.perl $MODELFILE $TH |
awk '{print $1, $2, $3}' > $OUT_GR/simil_${PREFIX} ;
cat $OUT_GR/simil_${PREFIX} |$EVAL/gold_mean.perl  $TEST_GR/golden-${LING}_svo.txt > $SIM/n-vn_dep

echo "End of similarity computation"
echo "Similarity files are in ./out/citius-$LING"
echo ""
###############################
##finishing similarity, begining evaluation
###############################
echo "Evaluation"

cat $SIM/n-vn_head |$EVAL/mean.perl $SIM/n-vn_dep  > $SIM/n-vn_merged
cat $SIM/nv-n_head |$EVAL/mean.perl $SIM/nv-n_dep  > $SIM/nv-n_merged

cat $SIM/n-vn_merged |$EVAL/mean.perl $SIM/nv-n_merged  > $SIM/nvn

#python $EVAL/evaluate_similarities.py --in_dir simil/citius-$LING -m spearman -c 3,4 -l $EVAL/all.log > $RESULTS/results_$LING.txt
cd eval
for i in ../simil/citius-$LING/* ; do echo $i >> __x; cat $i | cut -d " " -f 3 > y ;cat $i| cut -d " " -f 4 > yy ; java -jar task2-scorer.jar y yy  >> __x; done
mv __x ../eval/results/results_$LING.txt
cd ..


echo ""
echo "End of evaluation"
echo "Please, consult the evaluation scores (spearman) in ./eval/results"
