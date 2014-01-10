/*register /usr/local/lib/accumulo/lib/accumulo-core.jar;
register /usr/local/lib/accumulo/lib/accumulo-server.jar;
register /usr/local/lib/accumulo/lib/accumulo-fate.jar;
register /usr/local/lib/accumulo/lib/accumulo-trace.jar;
register /usr/local/lib/accumulo/lib/libthrift.jar;
register /usr/local/lib/zookeeper/zookeeper-3.4.5.jar;*/

grades = LOAD 'accumulo://grades?instance=accumulo15&user=root&password=secret&zookeepers=localhost' using
org.apache.pig.backend.hadoop.accumulo.AccumuloStorage() as (key:bytearray, m:map[]);

b = FOREACH grades generate key as name, (double) m#'gpa' as gpa;

sorted = ORDER b BY  gpa;

dump sorted;
