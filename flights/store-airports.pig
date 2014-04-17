airport_data = LOAD '/airports.csv' using PigStorage(',') as (code:chararray, name:chararray, city:chararray,
        state:chararray, country:chararray, latitude:chararray, longitude:chararray);

airport_data = FOREACH airport_data GENERATE REPLACE(code, '"', '') as rowkey,
       REPLACE(code, '"', ''), REPLACE(name, '"', ''), REPLACE(city, '"', ''), REPLACE(state, '"', ''), 
       REPLACE(country, '"', ''), REPLACE(latitude, '"', ''), REPLACE(longitude, '"', '');

STORE airport_data into 'accumulo://airports?instance=accumulo151&user=root&password=secret&zookeepers=localhost' using
org.apache.pig.backend.hadoop.accumulo.AccumuloStorage('code,name,city,state,country,latitude,longitude');

