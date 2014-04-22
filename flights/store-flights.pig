-- flight_data = LOAD '/small-flights.csv' using PigStorage(',') as (year:int, month:int, dayofmonth:int, dayofweek:int,
flight_data = LOAD '/flights.csv' using PigStorage(',') as (year:int, month:int, dayofmonth:int, dayofweek:int,
        departure_time:int, scheduled_departure_time:int, arrival_time:int ,scheduled_arrival_time:int ,
        carrier:chararray, flight_number:int , tail_number:chararray, actual_elapsed_time:int,
        scheduled_elapsed_time:int, air_time:int, arrival_delay:int, departure_delay:int, origin:chararray,
        destination:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray,
        diverted:int, carrier_delay:chararray, weather_delay:chararray, nas_delay:chararray, security_delay:chararray,
        late_aircraft_delay:chararray);

flight_data = FOREACH flight_data GENERATE CONCAT((chararray)year, CONCAT(CONCAT((chararray)month,
                (chararray)dayofmonth), CONCAT('_', CONCAT(carrier,
                    CONCAT('_', (chararray)flight_number))))) as rowkey,
       departure_time, scheduled_departure_time, arrival_time, scheduled_arrival_time, carrier, flight_number,
       tail_number, actual_elapsed_time, scheduled_elapsed_time, air_time, 
       arrival_delay, departure_delay, origin, destination, distance, taxi_in, taxi_out, cancelled, cancellation_code,
       diverted, carrier_delay, weather_delay, nas_delay, 
       security_delay, late_aircraft_delay;

STORE flight_data into 'accumulo://flights?instance=accumulo160bin&user=root&password=secret&zookeepers=localhost' using
org.apache.pig.backend.hadoop.accumulo.AccumuloStorage('departure_time,scheduled_departure_time,arrival_time,scheduled_arrival_time,carrier,flight_number,tail_number,actual_elapsed_time,scheduled_elapsed_time,air_time,arrival_delay,departure_delay,origin,destination,distance,taxi_in,taxi_out,cancelled,cancellation_code,diverted,carrier_delay,weather_delay,nas_delay,security_delay,late_aircraft_delay','-buff 10485760');

