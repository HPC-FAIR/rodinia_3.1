#!/bin/bash

NUM_PROCESSORS="$(lscpu | grep "^CPU(s):" | grep -o -E '[0-9]+')"
THREADS_PER_CORE="$(lscpu | grep "^Thread(s) per core:" | grep -o -E '[0-9]+')"
CORE_NUMBERS=$(expr $NUM_PROCESSORS / $THREADS_PER_CORE)

CPUPERFTOOL=vtune 
APP=(particle_filter )

DATADIR="../../data/particlefilter" 

# loop over application variants
for app in "${APP[@]}";
do
LOGDIR="$app-log"
mkdir -p $LOGDIR
file="$LOGDIR/rawdata.csv"
TOOLLOG=${LOGDIR}/${CPUPERFTOOL}

echo "App, thread, inputdata, exetime " > "$file"
# loop over dataset
for (( inputdata=128; inputdata <= 1024; inputdata*=2 )); 
do
for (( t=${CORE_NUMBERS}; t >= 4; t/=2 )); 
do
  TESTINPUT=$inputdata  
  export OMP_NUM_THREADS=$t
  echo "Vtune command: $CPUPERFTOOL  -collect threading -r $TOOLLOG/particlefilter_tr_${t}_${TESTINPUT} --  $app -x $inputdata -y $inputdata -z 10 -np 10000 "
  $CPUPERFTOOL  -collect threading -r $TOOLLOG/particlefilter_tr_${t}_${TESTINPUT} --  $app -x $inputdata -y $inputdata -z 10 -np 10000
  echo "Vtune command: $CPUPERFTOOL -report summary -format=csv -report-knob show-issues=false  -r $TOOLLOG/particlefilter_tr_${t}_${TESTINPUT} > $TOOLLOG/${t}_${TESTINPUT}_tr.log "
  $CPUPERFTOOL -report summary -format=csv -report-knob show-issues=false  -r $TOOLLOG/particlefilter_tr_${t}_${TESTINPUT} > $TOOLLOG/${t}_${TESTINPUT}_tr.log 
#

  echo "Vtune command: $CPUPERFTOOL  -collect hpc-performance -r $TOOLLOG/particlefilter_hpc_${t}_${TESTINPUT} --  $app -x $inputdata -y $inputdata -z 10 -np 10000"
  $CPUPERFTOOL  -collect hpc-performance -r $TOOLLOG/particlefilter_hpc_${t}_${TESTINPUT} --  $app -x $inputdata -y $inputdata -z 10 -np 10000
  echo "Vtune command: $CPUPERFTOOL -report summary -format=csv -report-knob show-issues=false  -r $TOOLLOG/particlefilter_hpc_${t}_${TESTINPUT} > $TOOLLOG/${t}_${TESTINPUT}_hpc.log "
  $CPUPERFTOOL -report summary -format=csv -report-knob show-issues=false  -r $TOOLLOG/particlefilter_hpc_${t}_${TESTINPUT} > $TOOLLOG/${t}_${TESTINPUT}_hpc.log 
#  exectime=$(grep -oP '(?<=Compute time: )[0-9]+\.[0-9]*' tmp.log)
#  echo "$app,$t,$TESTINPUT,$exectime" >> "$file" 
done
done
done


