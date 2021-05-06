#!/bin/bash

NUM_PROCESSORS="$(lscpu | grep "^CPU(s):" | grep -o -E '[0-9]+')"
THREADS_PER_CORE="$(lscpu | grep "^Thread(s) per core:" | grep -o -E '[0-9]+')"
CORE_NUMBERS=$(expr $NUM_PROCESSORS / $THREADS_PER_CORE)

CPUPERFTOOL=vtune 
APP=(lavaMD )

DATADIR="../../data/lavaMD" 

# loop over application variants
for app in "${APP[@]}";
do
LOGDIR="$app-log"
mkdir -p $LOGDIR
file="$LOGDIR/rawdata.csv"
TOOLLOG=${LOGDIR}/${CPUPERFTOOL}

echo "App, thread, inputdata, exetime " > "$file"
# loop over dataset
for (( inputdata=10; inputdata <= 100; inputdata+=10 )); 
do
for (( t=${CORE_NUMBERS}; t >= 4; t/=2 )); 
do
  TESTINPUT=$inputdata  
  echo "Vtune command: $CPUPERFTOOL  -collect threading -r $TOOLLOG/lavaMD_tr_${t}_${TESTINPUT} --  $app -cores $t -boxes1d $inputdata "
  $CPUPERFTOOL  -collect threading -r $TOOLLOG/lavaMD_tr_${t}_${TESTINPUT} --  $app -cores $t -boxes1d $inputdata
  echo "Vtune command: $CPUPERFTOOL -report summary -format=csv -report-knob show-issues=false  -r $TOOLLOG/lavaMD_tr_${t}_${TESTINPUT} > $TOOLLOG/${t}_${TESTINPUT}_tr.log "
  $CPUPERFTOOL -report summary -format=csv -report-knob show-issues=false  -r $TOOLLOG/lavaMD_tr_${t}_${TESTINPUT} > $TOOLLOG/${t}_${TESTINPUT}_tr.log 
#

  echo "Vtune command: $CPUPERFTOOL  -collect hpc-performance -r $TOOLLOG/lavaMD_hpc_${t}_${TESTINPUT} --  $app -cores $t -boxes1d $inputdata "
  $CPUPERFTOOL  -collect hpc-performance -r $TOOLLOG/lavaMD_hpc_${t}_${TESTINPUT} --  $app -cores $t -boxes1d $inputdata
  echo "Vtune command: $CPUPERFTOOL -report summary -format=csv -report-knob show-issues=false  -r $TOOLLOG/lavaMD_hpc_${t}_${TESTINPUT} > $TOOLLOG/${t}_${TESTINPUT}_hpc.log "
  $CPUPERFTOOL -report summary -format=csv -report-knob show-issues=false  -r $TOOLLOG/lavaMD_hpc_${t}_${TESTINPUT} > $TOOLLOG/${t}_${TESTINPUT}_hpc.log 
#  exectime=$(grep -oP '(?<=Compute time: )[0-9]+\.[0-9]*' tmp.log)
#  echo "$app,$t,$TESTINPUT,$exectime" >> "$file" 
done
done
done


