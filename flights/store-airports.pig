airport_data = LOAD '/trimmed-airports.csv' using PigStorage(',') as (code:chararray, name:chararray, city:chararray,
        state:chararray, country:chararray, latitude:float, longitude:float);

/*airport_data = FOREACH airport_data GENERATE REPLACE(code, '"', '') as rowkey,
       REPLACE(code, '"', ''), REPLACE(name, '"', ''), REPLACE(city, '"', ''), REPLACE(state, '"', ''), 
       REPLACE(country, '"', ''), REPLACE(latitude, '"', ''), REPLACE(longitude, '"', '');*/

STORE airport_data into 'accumulo://float-airports?instance=accumulo15&user=root&password=secret&zookeepers=localhost' using
org.apache.pig.backend.hadoop.accumulo.AccumuloStorage('name,city,state,country,latitude,longitude');

