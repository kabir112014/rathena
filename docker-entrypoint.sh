#!/bin/bash

echo "Version 5"

if [[ $SERVER_TYPE = 'login' ]]; then
    echo 'Running login-server'
    /rathena/login-server
elif [[ $SERVER_TYPE = 'char' ]]; then
    echo 'Running char-server'
    /rathena/char-server
elif [[ $SERVER_TYPE = 'map' ]]; then
    echo 'Running map-server'
    /rathena/map-server
elif [[ $SERVER_TYPE = 'web' ]]; then
    echo 'Running web-server'
    /rathena/web-server
elif [[ -z $SERVER_TYPE ]]; then
    echo 'The SERVER_TYPE variable is not set'
    echo 'Please set it to one of the following:'
    echo '  1. login'
    echo '  2. char'
    echo '  3. map'
    echo '  4. web'
else
    echo "Unknown server type: $SERVER_TYPE"
fi