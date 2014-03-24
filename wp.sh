#!/bin/bash

# Simple wallpaper rotater/randomizer; uses a file to remember index.

##CONFIG##
WP_DIR="/home/scott/images/wallpaper/rotation/"


USAGE=<<EOL
Usage: wp.sh [next|rand]
EOL

if [ -z $1 ]; then
    echo "$USAGE"
    exit
fi

# Only break on newline (files can have spaces)
IFS='
'

# Returns path to nth next wallpaper.
#   $1 how many wallpapers to move.
incr() {
    # Attempt to retrieve our index, or just default to 0
    if [ -e "${WP_DIR}index" ]; then
        index=$(cat "${WP_DIR}index")
    else
        index=0
    fi

    # Get array of all the possible images
    wallpapers=(`find -L $WP_DIR -type f -regex .*.[png,jpg,jpeg]`)
    # We wrap on overflow/underflow
    wallpaper_count=${#wallpapers[*]}
    # Increment
    index=$(( ($index + $1) % $wallpaper_count ))
    # Remember index next time
    echo $index > "${WP_DIR}index"

    # Return path to wallpaper
    echo ${wallpapers[$index]}
}

# Returns path to random wallpaper.
rand() {
    # Get a listing of all images files under the directory, then sort it randomly
    # and pick the first file out
    echo $(find -L $WP_DIR -type f -regex .*.[png,jpg,jpeg] | sort -R | head -n 1)
}

case $1 in
    'next')
        wp=$(incr 1)
        ;;
    'prev')
        wp=$(incr -1)
        ;;
    'rand')
        wp=$(rand)
        ;;
    *)
        echo 'Unknown option: '$1
        exit
        ;;
esac

# Set wallpaper, feh takes care of remembering it
feh --bg-fill $wp

