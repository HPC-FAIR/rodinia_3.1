#!/bin/bash
GPUPERFTOOL=nvprof
GPUPERFFLAG="--events all --metrics all"
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

echo "App, thread, inputdata, exetime " > "$file"
# loop over dataset
for (( f=10; f <= 40; f+=10 )); 
do
  echo "Test command: $GPUPERFTOOL  $GPUPERFFLAG -u ms --log-file $TOOLLOG/${f}.log $app $DATADIR/test.avi $f"
  $GPUPERFTOOL  $GPUPERFFLAG -u ms --log-file "$TOOLLOG/${f}.log" $app $DATADIR/test.avi $f
done
done


