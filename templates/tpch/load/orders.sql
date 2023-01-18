CREATE TABLE ORDERS (
        O_ORDERKEY              SERIAL8,
        O_CUSTKEY               BIGINT NOT NULL, -- references C_CUSTKEY
        O_ORDERSTATUS   CHAR(1),
        O_TOTALPRICE    DECIMAL,
        O_ORDERDATE             DATE,
        O_ORDERPRIORITY CHAR(15),
        O_CLERK                 CHAR(15),
        O_SHIPPRIORITY  INTEGER,
        O_COMMENT               VARCHAR(79)
)  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (o_orderkey);

\COPY orders FROM '/tmp/dss-data/orders.csv' WITH csv DELIMITER '|';