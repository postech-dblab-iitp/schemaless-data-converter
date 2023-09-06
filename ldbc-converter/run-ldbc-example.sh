DBNAME=$1

dropdb $DBNAME
createdb $DBNAME

bash ldbc.sh results 127.0.0.1 $DBNAME gpadmin gpadmin