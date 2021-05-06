#!/bin/bash

NUM_PROCESSORS="$(lscpu | grep "^CPU(s):" | grep -o -E '[0-9]+')"
THREADS_PER_CORE="$(lscpu | grep "^Thread(s) per core:" | grep -o -E '[0-9]+')"
CORE_NUMBERS=$(expr $NUM_PROCESSORS / $THREADS_PER_CORE)

CPUPERFTOOL=vtune 
APP=(srad1 )

DATADIR="../../data/srad" 

# loop over application variants
for app in "${APP[@]}";
do
LOGDIR="$app-log"
mkdir -p $LOGDIR
file="$LOGDIR/rawdata.csv"
TOOLLOG=${LOGDIR}/${CPUPERFTOOL}

echo "App, thread, inputdata, exetime " > "$file"
# loop over dataset
for (( r=64; r <= 512; r*=2 )); 
do
for (( c=64; c <= 512; c*=2 )); 
do
for (( t=${CORE_NUMBERS}; t >= 4; t/=2 )); 
do
  TESTINPUT="${r}_${c}" 
  echo "Vtune command: $CPUPERFTOOL  -collect threading -r $TOOLLOG/srad_tr_${t}_${TESTINPUT} --  $app 100 0.5 $r $c $t "
  $CPUPERFTOOL  -collect threading -r $TOOLLOG/srad_tr_${t}_${TESTINPUT} --  $app 100 0.5 $r $c $t
  echo "Vtune command: $CPUPERFTOOL -report summary -format=csv -report-knob show-issues=false  -r $TOOLLOG/srad_tr_${t}_${TESTINPUT} > $TOOLLOG/${t}_${TESTINPUT}_tr.log "
  $CPUPERFTOOL -report summary -format=csv -report-knob show-issues=false  -r $TOOLLOG/srad_tr_${t}_${TESTINPUT} > $TOOLLOG/${t}_${TESTINPUT}_tr.log 
#

  echo "Vtune command: $CPUPERFTOOL  -collect hpc-performance -r $TOOLLOG/srad_hpc_${t}_${TESTINPUT} --  $app 100 0.5 $r $c $t "
  $CPUPERFTOOL  -collect hpc-performance -r $TOOLLOG/srad_hpc_${t}_${TESTINPUT} --  $app 100 0.5 $r $c $t
  echo "Vtune command: $CPUPERFTOOL -report summary -format=csv -report-knob show-issues=false  -r $TOOLLOG/srad_hpc_${t}_${TESTINPUT} > $TOOLLOG/${t}_${TESTINPUT}_hpc.log "
  $CPUPERFTOOL -report summary -format=csv -report-knob show-issues=false  -r $TOOLLOG/srad_hpc_${t}_${TESTINPUT} > $TOOLLOG/${t}_${TESTINPUT}_hpc.log 
#  exectime=$(grep -oP '(?<=Compute time: )[0-9]+\.[0-9]*' tmp.log)
#  echo "$app,$t,$TESTINPUT,$exectime" >> "$file" 
done
done
done
done


