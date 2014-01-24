#!/bin/bash

# Script to ping a given IP at regular intervals and report dropped pings to a
# given email address.

##CONFIG##
# IP of service to check
IP='1.1.1.1'
# Minimum time in seconds between emails
INTERVAL=1800
# SMTP server and port
SMTP='alt3.gmail-smtp-in.l.google.com 25'
# Email address to send to
EMAIL='foo@bar.com'
# Email subject
SUBJECT='Foo bar'
# Email body
BODY='Baz qux'


# Make a new time file if none exists (set to 0 so script fires on first run)
if ! [ -e 'lastrun' ]; then
    echo '0' > lastrun
fi

# Determine the current time and the time
# we can send another email
NOW=`date +%s`
LASTRUN=`cat lastrun`
BREAK=$(($LASTRUN+$INTERVAL))

# Send if we have yet to send for INTERVAL seconds 
# and the service is unresponsive.
if [ $NOW -gt $BREAK ] && ! (ping -c 1 -W 10 $IP >/dev/null); then
    # Remember what time it is 
    echo $NOW > lastrun
    # Send the email
    ( 
    echo open $SMTP
    sleep 4
    echo helo $EMAIL
    echo mail from: \<$EMAIL\>
    sleep 2
    echo rcpt to: \<$EMAIL\>
    sleep 2
    echo data
    sleep 2
    echo From: $EMAIL
    echo To: $EMAIL
    echo subject: $SUBJECT
    echo
    echo
    echo $BODY
    sleep 2
    echo .
    sleep 2
    echo quit ) | telnet >mail.txt 
fi

