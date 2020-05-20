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

# Sanitize input and remove any leading zeros
CURRENT_MIN=$(expr ${TIME[1]} + 0);
CURRENT_HOUR=$(expr ${TIME[0]} + 0);
MAX_HOUR_ROLLOVER=24;

process_line() {
  # Replace wildcards with dash since bash doesn't play well with
  # them. Then convert the result into an array
  args=(${1//\*/-});

  minutes="${args[0]}";
  hour="${args[1]}";
  process="${args[2]}";

  if [ $minutes = "-" ]; then 
    if [ $hour != "-" ] && [ $hour != $CURRENT_HOUR ]; then
      minutes="00";
    else 
      minutes="$CURRENT_MIN";
    fi
  fi

  if [ $hour = "-" ]; then
    if [ $minutes -lt $CURRENT_MIN ]; then 
      hour="$(( ( $CURRENT_HOUR + 1 ) % MAX_HOUR_ROLLOVER ))";
    else
      hour="$CURRENT_HOUR";
    fi
  fi
  
  # Bit cludgy, but if the process time is less than now its going to happen tomorrow
  when=$( [ "$hour$minutes" -lt "$CURRENT_HOUR$CURRENT_MIN" ] && echo "tomorrow" || echo "today" )
  printf "%d:%02d %s - %s" $hour $minutes $when $process
}

if test ! -t 0; then
  while IFS= read -r line; do
    process_line "$line"
    # printf '%s\n' "$line"
  done
else 
  echo "No data passed with STDIN";
  exit 1;
fi
