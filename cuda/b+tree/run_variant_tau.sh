#!/bin/bash
GPUPERFTOOL=tau_exec
GPUPERFFLAG=" -T spectrum-cuda10-clang-papi-ompt-v5-mpi-cupti-pdt-openmp -cupti"
APP=(b+tree)

DATADIR="../../data/b+tree" 

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
  TESTINPUT="default"
  TAULOG=${TOOLLOG}/$inputdata
  mkdir -p $TAULOG 
  export PROFILEDIR=$TAULOG
  echo "Test command: $GPUPERFTOOL  $GPUPERFFLAG $app file $DATADIR/mil.txt command $DATADIR/command.txt"
  $GPUPERFTOOL  $GPUPERFFLAG $app file $DATADIR/mil.txt command $DATADIR/command.txt
  echo "Output log: pprof >> $TOOLLOG/${TESTINPUT}.log"
  pprof >> $TOOLLOG/${TESTINPUT}.log
  #exectime=$(grep -oP '(?<=Compute time: )[0-9]+\.[0-9]*' tmp.log)
  #echo "$app,$inputdata,$exectime" >> "$file" 
done


