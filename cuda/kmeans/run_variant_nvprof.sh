#!/bin/bash
GPUPERFTOOL=nvprof
GPUPERFFLAG="--events all --metrics all"
APP=(kmeans)

DATADIR="../../data/kmeans" 

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
for inputdata in "$DATADIR"/*.txt;
do
  TESTINPUT=$(basename $inputdata)  
  TESTINPUT="${TESTINPUT%.*}" 
  echo "Test command: $GPUPERFTOOL  $GPUPERFFLAG -u ms --log-file $TOOLLOG/${TESTINPUT}.log $app -o -i $inputdata "
  $GPUPERFTOOL  $GPUPERFFLAG -u ms --log-file "$TOOLLOG/${TESTINPUT}.log" $app -o -i $inputdata 
  #exectime=$(grep -oP '(?<=Compute time: )[0-9]+\.[0-9]*' tmp.log)
  #echo "$app,$inputdata,$exectime" >> "$file" 
#done
done
done


