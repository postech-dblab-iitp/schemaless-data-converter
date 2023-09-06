CREATE TABLE REGION (
        R_REGIONKEY     SERIAL8,
        R_NAME          CHAR(25),
        R_COMMENT       VARCHAR(152)
)  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (r_regionkey);

\COPY region FROM '/tmp/dss-data/region.csv' WITH csv DELIMITER '|';