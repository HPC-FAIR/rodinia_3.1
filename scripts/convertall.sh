#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

for d in $(find $SCRIPT_DIR/../ -type d -name "vtune");
do
	echo "process $d" 
	python3 $SCRIPT_DIR/convertVtuneOutput.py $d
done
