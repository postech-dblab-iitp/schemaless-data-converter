CREATE TABLE NATION (
        N_NATIONKEY             SERIAL8,
        N_NAME                  CHAR(25),
        N_REGIONKEY             BIGINT NOT NULL,  -- references R_REGIONKEY
        N_COMMENT               VARCHAR(152)
)  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (n_nationkey);

\COPY nation FROM '/tmp/dss-data/nation.csv' WITH csv DELIMITER '|';