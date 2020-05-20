#! /bin/bash
# Cursory tests to determine validity of the cron job checker


harness() {
  args=(${1//\*/-});

  minutes=$( [ ${args[0]} = "-" ] && echo "*" || echo "${args[0]}" );
  hour=$( [ ${args[1]} = "-" ] && echo "*" || echo "${args[1]}" );
  process="${args[2]}";
  time="${args[3]}";
  expected="${args[4]}";
  when="${args[5]}";

  result=$( echo "$minutes $hour $process" | ./check.sh "$time" );
  if [ "$result" = "$expected $when - $process" ]; then
    echo "[PASSED] $1";
  else 
    echo "[FAILED] $1:";
    echo "  Expected: $expected $when - $process";
    echo "  Received: $result";
    exit 1;
  fi;
}

echo "STATIC"
echo "------------------------------------------------"
harness "15 1 /bin/static 00:00 1:15 today"
harness "15 1 /bin/static 01:10 1:15 today"
harness "15 1 /bin/static 01:35 1:15 tomorrow"
harness "15 1 /bin/static 23:59 1:15 tomorrow"
echo ""

echo "EVERY HOUR"
echo "------------------------------------------------"
harness "15 * /bin/every_hour 00:00 0:15 today"
harness "15 * /bin/every_hour 01:10 1:15 today"
harness "15 * /bin/every_hour 01:35 2:15 today"
harness "15 * /bin/every_hour 23:59 0:15 tomorrow"
echo ""

echo "EVERY MIN"
echo "------------------------------------------------"
harness "* 1 /bin/every_min 00:00 1:00 today"
harness "* 1 /bin/every_min 01:35 1:35 today"
harness "* 1 /bin/every_min 23:59 1:00 tomorrow"
echo ""

echo "WILDCARD"
echo "------------------------------------------------"
harness "* * /bin/wildcard 00:00 0:00 today"
harness "* * /bin/wildcard 01:35 1:35 today"
harness "* * /bin/wildcard 23:59 23:59 today"
echo ""