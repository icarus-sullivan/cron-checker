This task should take less than two hours, however you can spend as long as you wish on it. Please don't feel you need to have a perfect solution - one that works is enough! 
We appreciate that you are spending your valuable personal time on this.
The problem:
We have a set of tasks, each running at least daily, which are scheduled with a simplified cron. We want to find when each of them will next run.
The scheduler configuration looks like this:
30 1 /bin/run_me_daily
45 * /bin/run_me_hourly
* * /bin/run_me_every_minute
* 19 /bin/run_me_sixty_times
The first field is the minutes past the hour, the second field is the hour of the day and the third is the command to run. For both cases * means that it should run for all values of that field. In the above example run_me_daily has been set to run at 1:30am every day and run_me_hourly at 45 minutes past the hour every hour. The fields are whitespace separated and each entry is on a separate line.
We would like you to write a command line program that outputs the soonest time at which each of the commands will run and whether this will be today or tomorrow.
The config input will be via STDIN, and the output should be via STDOUT. The 'current time' will be the single command line argument to the program in the format HH:MM.
For example given the above examples as input and the simulated 'current time' command-line argument 16:10 the output should be
1:30 tomorrow - /bin/run_me_daily
16:45 today - /bin/run_me_hourly
16:10 today - /bin/run_me_every_minute
19:00 today - /bin/run_me_sixty_times
You may use any programming language you are comfortable in to solve this problem, and you may use source code snippets found elsewhere as long as you can comprehensively explain them.
We will want to run your tool against an automated test suite, so please supply instructions for running it and installing any dependencies. Additionally, it must work on at least one of OSX and Linux (ideally both).