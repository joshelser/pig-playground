register /Users/jelser/projects/accumulo-pig.git/target/accumulo-pig-1.4.4-SNAPSHOT.jar;
register /Users/jelser/.m2/repository/org/apache/accumulo/accumulo-core/1.4.5-SNAPSHOT/accumulo-core-1.4.5-SNAPSHOT.jar;
register /usr/local/lib/accumulo/lib/libthrift-0.6.1.jar;
register /usr/local/lib/zookeeper/zookeeper-3.4.5.jar;
register /usr/local/lib/accumulo/lib/cloudtrace-1.4.5-SNAPSHOT.jar;

-- Read a reduced set of our flight data
flight_data = LOAD 'accumulo://flights?instance=accumulo1.4&user=root&password=secret&zookeepers=localhost&fetch_columns=destination,departure_time,scheduled_departure_time,flight_number,taxi_in,taxi_out,origin' using org.apache.accumulo.pig.AccumuloStorage() as (rowkey:chararray, data:map[]);

-- Also read airport information
airports = LOAD 'accumulo://airports?instance=accumulo1.4&user=root&password=secret&zookeepers=localhost' using org.apache.accumulo.pig.AccumuloStorage() as (rowkey:chararray, data:map[]);

-- Permute the map
flight_data = FOREACH flight_data generate rowkey, data#'origin' as origin, data#'destination' as destination, data#'departure_time' as departure_time, data#'scheduled_departure_time' as scheduled_departure_time, data#'flight_number' as flight_number, data#'taxi_in' as taxi_in, data#'taxi_out' as taxi_out;

-- Permute the map
airports = FOREACH airports GENERATE data#'name' as name, data#'state' as state, data#'code' as code, data#'country' as country, data#'city' as city;

-- Add airport information about the origin of the flight
flights_with_origin = JOIN flight_data BY origin, airports by code;

-- Store this information back into Accumulo in a new table
STORE flights_with_origin INTO 'accumulo://flights_with_airports?instance=accumulo1.4&user=root&password=secret&zookeepers=localhost' using org.apache.accumulo.pig.AccumuloStorage('origin,destination,departure_time,scheduled_departure_time,flight_number,taxi_in,taxi_out,name,state,code,country,city');
