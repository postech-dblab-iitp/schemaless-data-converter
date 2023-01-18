#!/bin/bash

DBNAME=$1
DATAPATH=$2

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
rm -rf results
bash benchmark_test.sh results 127.0.0.1 $DBNAME gpadmin gpadmin

# Restore the data
echo 'Remove dss folder and restore the temp folder'
rm -rf dss
mv temp dss