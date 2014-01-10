register /usr/local/lib/accumulo/lib/accumulo-core.jar;
register /usr/local/lib/accumulo/lib/accumulo-server.jar;
register /usr/local/lib/accumulo/lib/accumulo-fate.jar;
register /usr/local/lib/accumulo/lib/accumulo-trace.jar;
register /usr/local/lib/accumulo/lib/libthrift.jar;
register /usr/local/lib/zookeeper/zookeeper-3.4.5.jar;

airport_data = LOAD '/airports.csv' using PigStorage(',') as (code:chararray, name:chararray, city:chararray,
        state:chararray, country:chararray, latitude:chararray, longitude:chararray);

airport_data = FOREACH airport_data GENERATE REPLACE(code, '"', '') as rowkey,
       REPLACE(code, '"', ''), REPLACE(name, '"', ''), REPLACE(city, '"', ''), REPLACE(state, '"', ''), 
       REPLACE(country, '"', ''), REPLACE(latitude, '"', ''), REPLACE(longitude, '"', '');

STORE airport_data into 'accumulo://airports?instance=accumulo15&user=root&password=secret&zookeepers=localhost' using
org.apache.pig.backend.hadoop.accumulo.AccumuloStorage('--write-columns code,name,city,state,country,latitude,longitude');

