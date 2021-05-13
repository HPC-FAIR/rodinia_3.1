#!/bin/bash
GPUPERFTOOL=nvprof
GPUPERFFLAG="--events all --metrics all"
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

echo "App, thread, inputdata, exetime " > "$file"
# loop over dataset
for inputdata in "$DATADIR"/*.in;
do
  TESTINPUT=$(basename $inputdata)  
  TESTINPUT="${TESTINPUT%.*}" 
  echo "Test command: $GPUPERFTOOL  $GPUPERFFLAG -u ms --log-file $TOOLLOG/${TESTINPUT}.log $app $inputdata"
  $GPUPERFTOOL  $GPUPERFFLAG -u ms --log-file "$TOOLLOG/${TESTINPUT}.log" $app $inputdata
  #exectime=$(grep -oP '(?<=Compute time: )[0-9]+\.[0-9]*' tmp.log)
  #echo "$app,$inputdata,$exectime" >> "$file" 
done
done


