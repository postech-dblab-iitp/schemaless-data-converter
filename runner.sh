#!/bin/bash

DBNAME=$1
DATAPATH=$2

# Move original datas
mv /home/TPCH-Greenplum/dss /home/TPCH-Greenplum/temp

# Make dss folder
mkdir /home/TPCH-Greenplum/dss
mkdir /home/TPCH-Greenplum/dss/data
mkdir /home/TPCH-Greenplum/dss/queries

# Move generated data
cp ${DATAPATH}/*.csv /home/TPCH-Greenplum/dss/data
cp ./data/tpch/*.csv /home/TPCH-Greenplum/dss/data
cp ${DATAPATH}/*.sql /home/TPCH-Greenplum/dss

# Move to the folder
cd /home/TPCH-Greenplum

# Run test
rm -rf results
bash benchmark_test.sh results 127.0.0.1 $DBNAME gpadmin gpadmin

# Restore the data
rm -rf dss
mv temp dss