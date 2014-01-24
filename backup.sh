#!/bin/bash

# Simple backup to remote server with rsync over ssh
# Creates delta-backups (i.e. incremental) after the first run
# Idea from Michael Jakl at ibm.com

# We assume the filter is in the same directory as the script
cd `dirname $0`

# Source Information
SRC_PATH=/
FILTER=backup_filter

# Destination Information
DEST_USER=scott
DEST_HOST=rpi-office
DEST_PATH=/mnt/backup/`hostname`

# To identify backup (Date-Time)
name=`date "+%F_%T"`

# (a)rchive with compression (z), prune empty (m), delete extraneous, increment
# from latest; 
rsync $1 --progress -amzh --delete --filter=". $FILTER" \
    --link-dest=$DEST_PATH/latest $SRC_PATH $DEST_HOST:$DEST_PATH/$name

# Maintain the incremental backup scheme by using a symlink to remember the
#   most recent backup.
ssh $DEST_USER@$DEST_HOST <<EOI
if [ -e $DEST_PATH/$name ]
then
    [ -L $DEST_PATH/latest ] && rm $DEST_PATH/latest
    ln -s $DEST_PATH/$name $DEST_PATH/latest
else
    echo "Error: Failed to create link for backup $name" >> $DEST_PATH/err.log
fi
sync
EOI
