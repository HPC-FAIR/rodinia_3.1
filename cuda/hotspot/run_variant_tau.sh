#!/bin/bash
GPUPERFTOOL=tau_exec
GPUPERFFLAG=" -T spectrum-cuda10-clang-papi-ompt-v5-mpi-cupti-pdt-openmp -cupti"
APP=(hotspot)

DATADIR="../../data/hotspot" 

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
for inputdata in 64 512 1024;
do
# for (( t=8; t<=128; t*=2 )); 
# do
  TAULOG=${TOOLLOG}/$inputdata
  mkdir -p $TAULOG 
  export PROFILEDIR=$TAULOG
  tempinut=$DATADIR/temp_${inputdata}
  powerinput=$DATADIR/power_${inputdata}
  echo "Test command: $GPUPERFTOOL  $GPUPERFFLAG $app $inputdata 2 2  $tempinut $powerinput output.out"
  $GPUPERFTOOL  $GPUPERFFLAG $app $inputdata 2 2 $tempinut $powerinput output.out &> tmp.log
  echo "Output log: pprof >> $TOOLLOG/${inputdata}.log"
  pprof >> $TOOLLOG/${inputdata}.log
  #exectime=$(grep -oP '(?<=Compute time: )[0-9]+\.[0-9]*' tmp.log)
  #echo "$app,$inputdata,$exectime" >> "$file" 
#done
done
done


