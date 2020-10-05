#!/bin/sh

if [ "$(var DNS_ENABLED)" = "true" ]
then
    if [ "$(ps | grep "dnsmasq" | wc -l)" -gt 1 ]
    then
        log -d "Dnsmasq is running."
    else
        log -e "Dnsmasq is not running."
        exit 1;
    fi
fi

exit 0;
