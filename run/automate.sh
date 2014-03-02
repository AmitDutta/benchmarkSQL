#!/bin/bash
#$1 = db config file name (e.g postgres.properties, mySQL.properties)
logfilename=$1"_"$(date "+%m-%d-%Y_%H-%M-%S")".txt"
touch $logfilename
for ((i=1; i<=$2; ++i))
do
	start=$(date +%s%N)
	bash runSQL.sh $1 sqlTableCreates
	bash loadData.sh $1 numWarehouses 10
	bash runSQL $1 sqlIndexCreates
	bash runBenchmark $1
	bash runSQL.sh $1 sqlTableDrops 
	end=$(date +%s%N)
	diff=$(( $end - $start ))
	echo "Iteration: $i, Time: $diff nanoseconds" >> $logfilename
done
