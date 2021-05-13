#!/bin/bash
GPUPERFTOOL=tau_exec
GPUPERFFLAG=" -T spectrum-cuda10-clang-papi-ompt-v5-mpi-cupti-pdt-openmp -cupti"
APP=(pavle)

DATADIR="../../data/huffman" 

# loop over application variants
for app in "${APP[@]}";
do
LOGDIR="$app-log"
mkdir -p $LOGDIR
file="$LOGDIR/rawdata.csv"
TOOLLOG=${LOGDIR}/${GPUPERFTOOL}
mkdir -p $TOOLLOG


export TAU_SET_NODE=0

echo "App, thread, inputdata, exetime " > "$file"
# loop over dataset
for inputdata in "$DATADIR"/*.in;
do
  TAULOG=${TOOLLOG}/$inputdata
  mkdir -p $TAULOG 
  export PROFILEDIR=$TAULOG
  TESTINPUT=$(basename $inputdata)  
  TESTINPUT="${TESTINPUT%.*}" 
  echo "Test command: $GPUPERFTOOL  $GPUPERFFLAG $app $inputdata "
  $GPUPERFTOOL  $GPUPERFFLAG $app $inputdata 
  echo "Output log: pprof >> $TOOLLOG/${TESTINPUT}.log"
  pprof >> $TOOLLOG/${TESTINPUT}.log
  #exectime=$(grep -oP '(?<=Compute time: )[0-9]+\.[0-9]*' tmp.log)
  #echo "$app,$inputdata,$exectime" >> "$file" 
#done
done
done


