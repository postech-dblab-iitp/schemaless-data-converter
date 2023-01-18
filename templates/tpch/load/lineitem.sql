CREATE TABLE LINEITEM (
        L_ORDERKEY              BIGINT NOT NULL, -- references O_ORDERKEY
        L_PARTKEY               BIGINT NOT NULL, -- references P_PARTKEY (compound fk to PARTSUPP)
        L_SUPPKEY               BIGINT NOT NULL, -- references S_SUPPKEY (compound fk to PARTSUPP)
        L_LINENUMBER    INTEGER,
        L_QUANTITY              DECIMAL,
        L_EXTENDEDPRICE DECIMAL,
        L_DISCOUNT              DECIMAL,
        L_TAX                   DECIMAL,
        L_RETURNFLAG    CHAR(1),
        L_LINESTATUS    CHAR(1),
        L_SHIPDATE              DATE,
        L_COMMITDATE    DATE,
        L_RECEIPTDATE   DATE,
        L_SHIPINSTRUCT  CHAR(25),
        L_SHIPMODE              CHAR(10),
        L_COMMENT               VARCHAR(44)
)  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (l_orderkey, l_linenumber);

\COPY lineitem FROM '/tmp/dss-data/lineitem.csv' WITH csv DELIMITER '|';