-- using 1674113663 as a seed to the RNG


explain (FORMAT JSON) select
	sum(l_extendedprice) / 7.0 as avg_yearly
from
	lineitem,
	part
where
	p_partkey = l_partkey
	and p_brand = 'Brand#43'
	and p_container = 'SM JAR'
	and l_quantity < (
		select 0.2 * avg(l_quantity)
		from lineitem
		where l_partkey = p_partkey
	);
