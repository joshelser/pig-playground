register /usr/local/lib/accumulo/lib/accumulo-core.jar;
register /usr/local/lib/accumulo/lib/accumulo-server.jar;
register /usr/local/lib/accumulo/lib/accumulo-fate.jar;
register /usr/local/lib/accumulo/lib/accumulo-trace.jar;
register /usr/local/lib/accumulo/lib/libthrift.jar;
register /usr/local/lib/zookeeper/zookeeper-3.4.5.jar;

flight_data = LOAD
'accumulo://flights?instance=accumulo15&user=root&password=secret&zookeepers=localhost'
using org.apache.pig.backend.hadoop.accumulo.AccumuloStorage('*') as (rowkey:chararray, data:map[]);

-- flight_data = FOREACH flight_data generate rowkey, data#'origin' as origin, data#'departure_time' as departure_time, data#'scheduled_departure_time' as scheduled_departure_time, data#'flight_number' as flight_number, data#'taxi_out' as taxi_out;

flight_data = LIMIT flight_data 100000;

-- airports = FOREACH airports GENERATE data#'name' as name, data#'state' as state, data#'code' as code, data#'country' as country, data#'city' as city;

-- dump airports;
dump flight_data;
