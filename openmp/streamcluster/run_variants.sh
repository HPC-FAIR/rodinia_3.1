#!/bin/bash

NUM_PROCESSORS="$(lscpu | grep "^CPU(s):" | grep -o -E '[0-9]+')"
THREADS_PER_CORE="$(lscpu | grep "^Thread(s) per core:" | grep -o -E '[0-9]+')"
CORE_NUMBERS=$(expr $NUM_PROCESSORS / $THREADS_PER_CORE)

CPUPERFTOOL=vtune 
APP=(sc_omp )

DATADIR="../../data/streamcluster" 

# loop over application variants
for app in "${APP[@]}";
do
LOGDIR="$app-log"
mkdir -p $LOGDIR
file="$LOGDIR/rawdata.csv"
TOOLLOG=${LOGDIR}/${CPUPERFTOOL}

echo "App, thread, inputdata, exetime " > "$file"
# loop over dataset
for (( n=256; n <= 65536; n*=2 )); 
do
for (( c=256; c <= n; c*=2 )); 
do
for (( t=${CORE_NUMBERS}; t >= 4; t/=2 )); 
do
  TESTINPUT="${n}_${c}" 
  echo "Vtune command: $CPUPERFTOOL  -collect threading -r $TOOLLOG/streamcluster_tr_${t}_${TESTINPUT} --  $app 10 20 256 $n $c 1000 none output.txt $t "
  $CPUPERFTOOL  -collect threading -r $TOOLLOG/streamcluster_tr_${t}_${TESTINPUT} --   $app 10 20 256 $n $c 1000 none output.txt $t
  echo "Vtune command: $CPUPERFTOOL -report summary -format=csv -report-knob show-issues=false  -r $TOOLLOG/streamcluster_tr_${t}_${TESTINPUT} > $TOOLLOG/${t}_${TESTINPUT}_tr.log "
  $CPUPERFTOOL -report summary -format=csv -report-knob show-issues=false  -r $TOOLLOG/streamcluster_tr_${t}_${TESTINPUT} > $TOOLLOG/${t}_${TESTINPUT}_tr.log 
#

  echo "Vtune command: $CPUPERFTOOL  -collect hpc-performance -r $TOOLLOG/streamcluster_hpc_${t}_${TESTINPUT} --   $app 10 20 256 $n $c 1000 none output.txt $t "
  $CPUPERFTOOL  -collect hpc-performance -r $TOOLLOG/streamcluster_hpc_${t}_${TESTINPUT} --   $app 10 20 256 $n $c 1000 none output.txt $t 
  echo "Vtune command: $CPUPERFTOOL -report summary -format=csv -report-knob show-issues=false  -r $TOOLLOG/streamcluster_hpc_${t}_${TESTINPUT} > $TOOLLOG/${t}_${TESTINPUT}_hpc.log "
  $CPUPERFTOOL -report summary -format=csv -report-knob show-issues=false  -r $TOOLLOG/streamcluster_hpc_${t}_${TESTINPUT} > $TOOLLOG/${t}_${TESTINPUT}_hpc.log 
#  exectime=$(grep -oP '(?<=Compute time: )[0-9]+\.[0-9]*' tmp.log)
#  echo "$app,$t,$TESTINPUT,$exectime" >> "$file" 
done
done
done
done


