#!/bin/bash

echo "copy queries"
rm -rf ./queries/tpch
mkdir ./queries/tpch
cp -r /home/TPCH-Greenplum/dss/queries/*.sql ./queries/tpch

echo "copy csv"
rm -rf ./data/tpch
mkdir ./data/tpch
cp -r /home/TPCH-Greenplum/dss/data/*.csv ./data/tpch