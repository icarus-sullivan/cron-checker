#!/bin/bash
# Check a list of upcoming cron jobs and display if they are happening today or tomorrow

IS_DIGIT='^[0-9]+$'

if [ $# -eq 0 ]; then
    echo "Please provide a time (HH:MM)"; exit 1;
fi

TIME=(${1//:/ });

# Check validity of input before assigning variables
if ! [[ ${TIME[0]} =~ $IS_DIGIT ]] ; then
   echo "Error: Hours not a number, valid range is (00..23)" >&2; exit 1;
fi

if ! [[ ${TIME[1]} =~ $IS_DIGIT ]] ; then
   echo "Error: Minutes not a number, valid range is (00..59)" >&2; exit 1;
fi

CURRENT_MIN=${TIME[1]};
CURRENT_HOUR=${TIME[0]};

process_line() {
  # Replace wildcards with dash since bash doesn't play well with
  # them. Then convert the result into an array
  args=(${1//\*/-});

  minutes="${args[0]}";
  hour="${args[1]}";
  process="${args[2]}";
  when="today"

  if [ $minutes = "-" ]; then
    # If we don't have a wildcard hour, then zero minutes
    if [ $hour != "-" ]; then 
      minutes="00";
    else 
      minutes="$CURRENT_MIN"
    fi
  fi

  if [ $hour = "-" ]; then
    # We missed the non-wildcard minute - increment the hour
    if [ $CURRENT_MIN -gt $minutes ]; then
      hour=$(($CURRENT_HOUR + 1 % ))
    else
      hour="$CURRENT_HOUR";
    fi
  fi
  
  # We've rolled over hours, set them to 00
  if [ $hour -gt 23 ]; then
    when="tomorrow";
    hour="00";
  fi

  if [ $CURRENT_HOUR -gt $hour ]; then
    when="tomorrow";
  fi
  
  echo "$hour:$minutes $when - $process";
}

if test ! -t 0; then
  while IFS= read -r line; do
    process_line "$line"
    # printf '%s\n' "$line"
  done
else 
  echo "No data provided, data should be passed through STDIN";
  exit 1;
fi
