#! /bin/bash

# Only valid use is with arguments 'up' or 'down'

BRIGHT_FILE=/sys/class/backlight/acpi_video0/brightness
CUR_BRIGHT=`cat $BRIGHT_FILE`

if [ -z $1 ]; then
    echo 'Usage: brightness.sh [up|down]'
    exit
elif [ $1 == 'up' ]; then
    let "CUR_BRIGHT++"
elif [ $1 == 'down' ]; then
    let "CUR_BRIGHT--"
fi

# Clamp the value within 0-7 inclusive 
# (this script isn't portable at all)
if [ $CUR_BRIGHT -gt 7 ]; then
    let "CUR_BRIGHT=7"
elif [ $CUR_BRIGHT -lt 0 ]; then
    let "CUR_BRIGHT=0"
fi

echo $CUR_BRIGHT > $BRIGHT_FILE
