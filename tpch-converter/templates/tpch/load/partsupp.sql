CREATE TABLE PARTSUPP (
        PS_PARTKEY              BIGINT NOT NULL, -- references P_PARTKEY
        PS_SUPPKEY              BIGINT NOT NULL, -- references S_SUPPKEY
        PS_AVAILQTY             INTEGER,
        PS_SUPPLYCOST   DECIMAL,
        PS_COMMENT              VARCHAR(199)
)  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (ps_partkey,ps_suppkey);

\COPY partsupp FROM '/tmp/dss-data/partsupp.csv' WITH csv DELIMITER '|';