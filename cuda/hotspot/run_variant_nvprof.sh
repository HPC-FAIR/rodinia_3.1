#!/bin/bash
GPUPERFTOOL=nvprof
GPUPERFFLAG="--events all --metrics all"
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

echo "App, thread, inputdata, exetime " > "$file"
# loop over dataset
for inputdata in 64 512 1024;
do
# for (( t=8; t<=128; t*=2 )); 
# do
  tempinut=$DATADIR/temp_${inputdata}
  powerinput=$DATADIR/power_${inputdata}
  echo "Test command: $GPUPERFTOOL  $GPUPERFFLAG -u ms --log-file $TOOLLOG/${inputdata}.log $app $inputdata 2 2  $tempinut $powerinput output.out"
  $GPUPERFTOOL  $GPUPERFFLAG -u ms --log-file "$TOOLLOG/${inputdata}.log" $app $inputdata 2 2 $tempinut $powerinput output.out &> tmp.log
  exectime=$(grep -oP '(?<=Compute time: )[0-9]+\.[0-9]*' tmp.log)
  echo "$app,$inputdata,$exectime" >> "$file" 
#done
done
done


