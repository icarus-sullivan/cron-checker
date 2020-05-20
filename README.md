
# Usage 

To check upcoming cron jobs, pipe properly formatted configuration to the `check.sh` script. Additionally provide a single argument non-namespaced for the given time of day you are querying. 


Example:

```bash
cat ./config.txt | ./check.sh 1:45
```

## Configuration

Configuration should be a white-space separated value set with the following structure:

| Column | Description | Type |
|--|--|--|
| 1 | Minutes to run the cron job on or wilcard for every minute | Number or String |
| 2 | Hour to run the cron job or wildcard for every hour | Number or String |
| 3 | The name of the process to run | String |

Example:
```
15 * /bin/run_every_hour_at_quarter_past
05 3 /bin/run_once_at_3_0_5
* * /bin/run_every_minute_of_every_hour
* 2 /bin/run_every_minute_of_2_o_clock
```

## Argument 

Generally you can use any combination of (0..23) for hours and (0..59) in regards to minutes. 

Example:
```bash
echo "* 0 /bin/test" | ./check.sh 00:00 # min 
echo "* 0 /bin/test" | ./check.sh 23:59 # max
```

## Tests

There are some cursory tests provided, to run invoke this script:

```bash
./test.sh
```
