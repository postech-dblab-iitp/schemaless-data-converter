CREATE TABLE SUPPLIER (
        S_SUPPKEY               SERIAL8,
        S_NAME                  CHAR(25),
        S_ADDRESS               VARCHAR(40),
        S_NATIONKEY             BIGINT NOT NULL, -- references N_NATIONKEY
        S_PHONE                 CHAR(15),
        S_ACCTBAL               DECIMAL,
        S_COMMENT               VARCHAR(101)
)  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (s_suppkey);

\COPY supplier FROM '/tmp/dss-data/supplier.csv' WITH csv DELIMITER '|';