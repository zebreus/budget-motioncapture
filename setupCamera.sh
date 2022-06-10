#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if grep -q 'bash '"$DIR"'/update.sh &' "/etc/rc.local"; then
    echo "Update already in rc.local"
else
    sed -i -e '$i bash '"$DIR"'/update.sh &\n' /etc/rc.local
    echo "Update inserted into rc.local"
fi
