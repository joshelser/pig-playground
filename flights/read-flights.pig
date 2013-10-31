register /Users/jelser/projects/accumulo-pig.git/target/accumulo-pig-1.4.4-SNAPSHOT.jar;
register /usr/local/lib/accumulo/lib/accumulo-core-1.4.5-SNAPSHOT.jar;
register /usr/local/lib/accumulo/lib/libthrift-0.6.1.jar;
register /usr/local/lib/zookeeper/zookeeper-3.4.5.jar;
register /usr/local/lib/accumulo/lib/cloudtrace-1.4.5-SNAPSHOT.jar;

flight_data = LOAD 'accumulo://flights?instance=accumulo1.4&user=root&password=secret&zookeepers=localhost&start=2001&end=2003&fetch_columns=origin,destination,departure_delay,arrival_delay' using org.apache.accumulo.pig.AccumuloStorage() as (rowkey:chararray, data:map[]);

delays = FILTER flight_data BY (data#'origin' is not null and data#'destination' is not null and data#'departure_delay' is not null and data#'arrival_delay' is not null);

dump delays;
