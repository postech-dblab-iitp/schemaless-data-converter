CREATE TABLE PART (
        P_PARTKEY               SERIAL8,
        P_NAME                  VARCHAR(55),
        P_MFGR                  CHAR(25),
        P_BRAND                 CHAR(10),
        P_TYPE                  VARCHAR(25),
        P_SIZE                  INTEGER,
        P_CONTAINER             CHAR(10),
        P_RETAILPRICE   DECIMAL,
        P_COMMENT               VARCHAR(23)
) with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (p_partkey);

\COPY part FROM '/tmp/dss-data/part.csv' WITH csv DELIMITER '|';