#!/bin/sh

FILENAME=$1

rm -rf result.txt

psql -h 127.0.0.1 -U gpadmin  -d ldbc-schemaless -f $FILENAME >> result.txt