flight_data = LOAD
'accumulo://flights?instance=accumulo15&user=root&password=secret&zookeepers=localhost&fetch_columns=departure_time,scheduled_departure_time,flight_number,taxi_out,origin'
using org.apache.pig.backend.hadoop.accumulo.AccumuloStorage() as (rowkey:chararray, data:map[]);

airports = LOAD 'accumulo://airports?instance=accumulo15&user=root&password=secret&zookeepers=localhost'
using org.apache.pig.backend.hadoop.accumulo.AccumuloStorage() as (rowkey:chararray, data:map[]);

flight_data = FOREACH flight_data generate rowkey, data#'origin' as origin, data#'departure_time' as departure_time, data#'scheduled_departure_time' as scheduled_departure_time, data#'flight_number' as flight_number, data#'taxi_out' as taxi_out;

--flight_data = LIMIT flight_data 100000;

airports = FOREACH airports GENERATE data#'name' as name, data#'state' as state, data#'code' as code, data#'country' as country, data#'city' as city;

flights_with_origin = JOIN flight_data BY origin, airports by code;

STORE flights_with_origin INTO
'accumulo://flights_with_airports?instance=accumulo15&user=root&password=secret&zookeepers=localhost' using
org.apache.pig.backend.hadoop.accumulo.AccumuloStorage('--write-columns origin,departure_time,scheduled_departure_time,flight_number,taxi_out,name,state,code,country,city');

--STORE airports INTO 'accumulo://new_airports?instance=accumulo1.5&user=root&password=secret&zookeepers=localhost' using
--org.apache.pig.backend.hadoop.accumulo.AccumuloStorage('name,state,code,country,city');
