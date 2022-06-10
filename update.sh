#! /bin/bash
# This script checks that the interface is up, and that an internet connection is available
# It is based on code from http://askubuntu.com/questions/3299/how-to-run-cron-job-when-network-is-up
#
# Then it sleeps for a random number of seconds between 30 and 600.
# This is based on code from http://tldp.org/LDP/abs/html/randomvar.html
#
# Collated by @JonTheNiceGuy on 2015-10-15

function check_google
{
  netcat -z -w 5 8.8.8.8 53 && echo 1 || echo 0
}

until [ `check_google` -eq 1 ]; do
  sleep 2
done

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
git pull
