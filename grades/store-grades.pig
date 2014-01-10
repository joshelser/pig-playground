/*register /usr/local/lib/accumulo/lib/accumulo-core.jar;
register /usr/local/lib/accumulo/lib/accumulo-server.jar;
register /usr/local/lib/accumulo/lib/accumulo-fate.jar;
register /usr/local/lib/accumulo/lib/accumulo-trace.jar;
register /usr/local/lib/accumulo/lib/libthrift.jar;
register /usr/local/lib/zookeeper/zookeeper-3.4.5.jar;*/

/*grades_raw = LOAD '/grades-map.csv' using PigStorage(',') as (name:chararray, m:map[]);*/
 grades_raw = LOAD '/grades.csv' using PigStorage(',') as (name:chararray, gpa:double, grade:chararray, semester:int); 

/*grades = FOREACH grades_raw GENERATE name as row, ['gpa' # gpa, 'grade' # grade, 'semester' # semester];*/

STORE grades_raw into 'accumulo://grades?instance=accumulo15&user=root&password=secret&zookeepers=localhost' using
org.apache.pig.backend.hadoop.accumulo.AccumuloStorage('gpa,grade,semester');

