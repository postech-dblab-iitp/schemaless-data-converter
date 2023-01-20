#!/bin/bash

DBNAME=$1
DATAPATH=$2
MODE=$3

# Move original datas
echo 'Moving original data to temp folder'
mv /home/TPCH-Greenplum/dss /home/TPCH-Greenplum/temp

# Make dss folder
echo 'Making dss folder'
mkdir /home/TPCH-Greenplum/dss
mkdir /home/TPCH-Greenplum/dss/data
mkdir /home/TPCH-Greenplum/dss/queries

# Move generated data
echo 'Moving generated data to dss folder'
cp ${DATAPATH}/*.csv /home/TPCH-Greenplum/dss/data
cp ./data/tpch/*.csv /home/TPCH-Greenplum/dss/data
cp ${DATAPATH}/*.sql /home/TPCH-Greenplum/dss
cp ${DATAPATH}/queries/*.sql /home/TPCH-Greenplum/dss/queries

# Move to the folder
echo 'Changing directory to TPCH-Greenplum'
cd /home/TPCH-Greenplum

# Run test
echo 'Running test'
if [ $3 == 'r' ] 
then
    rm -rf results1
    rm -rf results2
    rm -rf results3
    bash benchmark_test.sh results1 127.0.0.1 $DBNAME gpadmin gpadmin
    bash tpch_test_only.sh results2 127.0.0.1 $DBNAME gpadmin gpadmin
    bash tpch_test_only.sh results3 127.0.0.1 $DBNAME gpadmin gpadmin
else
    rm -rf results
    bash benchmark_test.sh results 127.0.0.1 $DBNAME gpadmin gpadmin
fi

# Restore the data
echo 'Remove dss folder and restore the temp folder'
rm -rf dss
mv temp dss