#!/bin/bash
GPUPERFTOOL=nvprof
GPUPERFFLAG="--events all --metrics all"
APP=(3D )

DATADIR="../../data/hotspot3D" 

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
for inputdata in "$DATADIR"/power*;
do
  echo $inputdata
  read k row layer <<<${inputdata//[^0-9]/ }
  TESTINPUT="${row}_${layer}"
  echo "Test command: $GPUPERFTOOL  $GPUPERFFLAG -u ms --log-file $TOOLLOG/${TESTINPUT}.log $app $row $layer 100 $DATADIR/power_${row}x${layer} $DATADIR/temp_${row}x${layer} output.txt"
  $GPUPERFTOOL  $GPUPERFFLAG -u ms --log-file "$TOOLLOG/${TESTINPUT}.log" $app $row $layer 100 $DATADIR/power_${row}x${layer} $DATADIR/temp_${row}x${layer} output.txt
  #exectime=$(grep -oP '(?<=Compute time: )[0-9]+\.[0-9]*' tmp.log)
  #echo "$app,$inputdata,$exectime" >> "$file" 
#done
done
done


