#!/bin/bash
GPUPERFTOOL=nvprof
GPUPERFFLAG="--events all --metrics all"
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

echo "App, thread, inputdata, exetime " > "$file"
# loop over dataset
  TESTINPUT="default"
  echo "Test command: $GPUPERFTOOL  $GPUPERFFLAG -u ms --log-file $TOOLLOG/${TESTINPUT}.log $app file $DATADIR/mil.txt command $DATADIR/command.txt"
  $GPUPERFTOOL  $GPUPERFFLAG -u ms --log-file "$TOOLLOG/${TESTINPUT}.log" $app file $DATADIR/mil.txt command $DATADIR/command.txt
  #exectime=$(grep -oP '(?<=Compute time: )[0-9]+\.[0-9]*' tmp.log)
  #echo "$app,$inputdata,$exectime" >> "$file" 
#done
done


