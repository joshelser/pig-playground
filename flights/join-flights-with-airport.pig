flight_data = LOAD 'accumulo://flights?instance=accumulo160bin&user=root&password=secret&zookeepers=localhost'
using
org.apache.pig.backend.hadoop.accumulo.AccumuloStorage('departure_time,scheduled_departure_time,flight_number,origin')
as (rowkey:chararray, departure_time:chararray, scheduled_departure_time:chararray, flight_number:chararray,
        origin:chararray);

airports = LOAD 'accumulo://airports?instance=accumulo160bin&user=root&password=secret&zookeepers=localhost'
using org.apache.pig.backend.hadoop.accumulo.AccumuloStorage('*') as (rowkey:chararray, data:map[]);
/*airports = LOAD 'accumulo://airports4?instance=accumulo15&user=root&password=secret&zookeepers=localhost'
using org.apache.pig.backend.hadoop.accumulo.AccumuloStorage('name,state,code,country,city') as (rowkey:chararray,
        name:chararray, state:chararray, code:chararray, country:chararray, city:chararray);

flight_data = FOREACH flight_data generate rowkey, data#'origin' as origin, data#'departure_time' as departure_time, data#'scheduled_departure_time' as scheduled_departure_time, data#'flight_number' as flight_number, data#'taxi_out' as taxi_out;*/

airports = FOREACH airports GENERATE (chararray) data#'name' as name, (chararray) data#'state' as state, (chararray)
data#'code' as code, (chararray) data#'country' as country, (chararray) data#'city' as city;


flights_with_origin = JOIN flight_data BY origin, airports by code;

STORE flights_with_origin INTO
'accumulo://flights_with_airports?instance=accumulo160bin&user=root&password=secret&zookeepers=localhost' using
org.apache.pig.backend.hadoop.accumulo.AccumuloStorage('departure_time,scheduled_departure_time,flight_number,origin,name,state,code,country,city','--buff 104857600');
