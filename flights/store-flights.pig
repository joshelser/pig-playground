register /Users/jelser/projects/accumulo-pig.git/target/accumulo-pig-1.4.4-SNAPSHOT.jar;
register /usr/local/lib/accumulo/lib/accumulo-core-1.4.5-SNAPSHOT.jar;
register /usr/local/lib/accumulo/lib/libthrift-0.6.1.jar;
register /usr/local/lib/zookeeper/zookeeper-3.4.5.jar;
register /usr/local/lib/accumulo/lib/cloudtrace-1.4.5-SNAPSHOT.jar;

DEFINE FORMAT org.apache.accumulo.pig.FORMAT();

flight_data = LOAD '/flights.csv' using PigStorage(',') as (year:int, month:int, dayofmonth:int, dayofweek:int, departure_time:int, scheduled_departure_time:int, arrival_time:int ,scheduled_arrival_time:int , carrier:chararray, flight_number:int , tail_number:chararray, actual_elapsed_time:int, scheduled_elapsed_time:int, air_time:int, arrival_delay:int, departure_delay:int, origin:chararray, destination:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:chararray, weather_delay:chararray, nas_delay:chararray, security_delay:chararray, late_aircraft_delay:chararray);

flight_data = FOREACH flight_data GENERATE CONCAT(FORMAT('%04d-%02d-%02d', year, month, dayofmonth), CONCAT('_', CONCAT(carrier, CONCAT('_', (chararray)flight_number)))) as rowkey,
       departure_time, scheduled_departure_time, arrival_time, scheduled_arrival_time, carrier, flight_number, tail_number, actual_elapsed_time, scheduled_elapsed_time, air_time, 
       arrival_delay, departure_delay, origin, destination, distance, taxi_in, taxi_out, cancelled, cancellation_code, diverted, carrier_delay, weather_delay, nas_delay, 
       security_delay, late_aircraft_delay;

STORE flight_data into 'accumulo://flights?instance=accumulo1.4&user=root&password=secret&zookeepers=localhost' using org.apache.accumulo.pig.AccumuloStorage('departure_time,scheduled_departure_time,arrival_time,scheduled_arrival_time,carrier,flight_number,tail_number,actual_elapsed_time,scheduled_elapsed_time,air_time,arrival_delay,departure_delay,origin,destination,distance,taxi_in,taxi_out,cancelled,cancellation_code,diverted,carrier_delay,weather_delay,nas_delay,security_delay,late_aircraft_delay');

