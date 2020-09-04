#!/bin/sh

if expr "${NETWORK}" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.0$' >/dev/null; then
    log -i "Adding route for communication with network $NETWORK/24";
    route add -net ${NETWORK} netmask 255.255.255.0 gw $(ip route | awk '/default/ { print $3 }')
else
    log -w "NETWORK missing or wrong format. Add this if you are experiencing communication problems.";
fi