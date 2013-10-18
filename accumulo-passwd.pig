register /Users/jelser/projects/accumulo-pig.git/target/accumulo-pig-1.4.4-SNAPSHOT.jar;
register /usr/local/lib/accumulo/lib/accumulo-core-1.4.5-SNAPSHOT.jar;
register /usr/local/lib/accumulo/lib/cloudtrace-1.4.5-SNAPSHOT.jar;
register /usr/local/lib/accumulo/lib/libthrift-0.6.1.jar;
register /usr/local/lib/zookeeper/zookeeper-3.4.5.jar;

-- Load into tuples
passwds = LOAD '/passwd' USING PigStorage(':') AS 
        (name:chararray, uhh:chararray, userid:int, groupid:int, description:chararray, home:chararray, shell:chararray);

-- Select username and login shell 
names_with_shell = FOREACH passwds GENERATE name, shell;

-- Filter out shells that are empty (bad parsing)
names_with_shell = FILTER names_with_shell BY shell != '';

-- Group the tuples by the shell
grouped_by_shells = GROUP names_with_shell BY shell;

-- For each shell, generate the number of users with that shell, as well as the users themselves
shell_histogram = FOREACH grouped_by_shells {
    names = FOREACH names_with_shell GENERATE name;
    GENERATE group, COUNT(names), BagToTuple(names);
};

acc = FILTER passwds BY shell != '';
acc = FOREACH acc GENERATE name, userid, groupid, (shell, 'foo');

--dump acc;
STORE acc into 'accumulo://typedpasswd?instance=accumulo1.4&user=root&password=secret&zookeepers=localhost:2181' using org.apache.accumulo.pig.TypedAccumuloStorage();

-- Print it all back out
--dump shell_histogram;
