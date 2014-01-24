#!/bin/bash

# Simple wallpaper rotater/randomizer; uses a file to remember index.

##CONFIG##
WP_DIR="/home/scott/images/wallpaper/rotation/"


USAGE=<<EOL
Usage: wp.sh [next|rand]
EOL

if [ -z $1 ]; then
    echo $USAGE
    exit
fi

# Only break on newline (files can have spaces)
IFS='
'

# Returns path to next wallpaper.
next() {
    # Attempt to retrieve our index
    if [ -e "${WP_DIR}index" ]; then
        index=$(cat "${WP_DIR}index")
    else
        # if the file does not exist we'll start fresh
        index=0
    fi

    # Get array of all the possible images
    wallpapers=(`find -L $WP_DIR -type f -regex .*.[png,jpg,jpeg]`)

    # Check for overflow and wrap back if we have
    len=${#wallpapers[*]}
    if [[ $index -ge $len ]]; then
        index=0
    fi

    #Increment the index so we hit the next one upon next invocation
    echo $(($index+1)) > "${WP_DIR}index"

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
        wp=$(next)
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

