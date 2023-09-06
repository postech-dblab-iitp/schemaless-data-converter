#!/bin/sh

RESULTS=$1
HOST=$2
DBNAME=$3
USER=$4
PWD=$5
# delay between stats collections (iostat, vmstat, ...)
DELAY=15

# DSS queries timeout (5 minutes or something like that)
DSS_TIMEOUT=300000 # 5 minutes in seconds

# log
LOGFILE=bench.log

function benchmark_run() {

	mkdir -p $RESULTS

	# store the settings
	psql -h $HOST -U $USER postgres -c "select name,setting from pg_settings" > $RESULTS/settings.log 2> $RESULTS/settings.err

	print_log "preparing LDBC database"

	# create database, populate it with data and set up foreign keys
	psql -h $HOST -U $USER $DBNAME < ./original-queries/ddl/schemas.sql > $RESULTS/create.log 2> $RESULTS/create.err

	print_log "  loading data"

	psql -h $HOST -U $USER $DBNAME < ./original-queries/ddl/load.sql > $RESULTS/load.log 2> $RESULTS/load.err

	print_log "  schema constraints"

	psql -h $HOST -U $USER $DBNAME < ./original-queries/ddl/schema_constraints.sql > $RESULTS/constraints.log 2> $RESULTS/constraints.err

	# print_log "  creating foreign keys"

	# psql -h $HOST -U $USER $DBNAME < ./original-queries/ddl/schema_foreign_keys.sql > $RESULTS/foreign.log 2> $RESULTS/foreign.err

	print_log "  analyzing"

	psql -h $HOST -U $USER $DBNAME < ./original-queries/ddl/analyze.sql > $RESULTS/analyze.log 2> $RESULTS/analyze.err
}

function print_log() {

	local message=$1

	echo `date +"%Y-%m-%d %H:%M:%S"` "["`date +%s`"] : $message" >> $RESULTS/$LOGFILE;

}

mkdir $RESULTS;

export PGPASSWORD=$PWD

# run the benchmark
benchmark_run $RESULTS $DBNAME $USER
