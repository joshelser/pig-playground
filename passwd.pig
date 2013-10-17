-- Load into tuples
passwds = LOAD '/etc/passwd' USING PigStorage(':') AS 
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

-- Print it all back out
dump shell_histogram;
