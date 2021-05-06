#!/bin/bash
GPUPERFTOOL=tau_exec
GPUPERFFLAG=" -T spectrum-cuda10-clang-papi-ompt-v5-mpi-cupti-pdt-openmp -cupti"
APP=(heartwall)

DATADIR="../../data/heartwall" 

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
for (( f=10; f <= 40; f+=10 )); 
do
  TAULOG=${TOOLLOG}/$f
  mkdir -p $TAULOG 
  export PROFILEDIR=$TAULOG
  echo "Test command: $GPUPERFTOOL  $GPUPERFFLAG $app $DATADIR/test.avi $f"
  $GPUPERFTOOL  $GPUPERFFLAG $app $DATADIR/test.avi $f
  echo "Output log: pprof >> $TOOLLOG/${f}.log"
  pprof >> $TOOLLOG/${f}.log
done
done


