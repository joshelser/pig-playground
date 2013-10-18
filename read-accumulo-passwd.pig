register /Users/jelser/projects/accumulo-pig.git/target/accumulo-pig-1.4.4-SNAPSHOT.jar;
register /usr/local/lib/accumulo/lib/accumulo-core-1.4.5-SNAPSHOT.jar;
register /usr/local/lib/accumulo/lib/cloudtrace-1.4.5-SNAPSHOT.jar;
register /usr/local/lib/accumulo/lib/libthrift-0.6.1.jar;
register /usr/local/lib/zookeeper/zookeeper-3.4.5.jar;

-- Load into tuples
passwds = LOAD 'accumulo://typedpasswd?instance=accumulo1.4&user=root&password=secret&zookeepers=localhost:2181' using org.apache.accumulo.pig.TypedAccumuloStorage() as (name:chararray, userid:int, groupid:int, cv:bytearray, ts:long, value:tuple(chararray, chararray));

describe passwds;
