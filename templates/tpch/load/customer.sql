CREATE TABLE CUSTOMER (
        C_CUSTKEY               SERIAL8,
        C_NAME                  VARCHAR(25),
        C_ADDRESS               VARCHAR(40),
        C_NATIONKEY             BIGINT NOT NULL, -- references N_NATIONKEY
        C_PHONE                 CHAR(15),
        C_ACCTBAL               DECIMAL,
        C_MKTSEGMENT    CHAR(10),
        C_COMMENT               VARCHAR(117)
)  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (c_custkey);

\COPY customer FROM '/tmp/dss-data/customer.csv' WITH csv DELIMITER '|';