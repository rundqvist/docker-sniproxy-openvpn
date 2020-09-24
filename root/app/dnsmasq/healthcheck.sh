#!/bin/sh

if [ "$(var DNS_ENABLED)" = "true" ] ; then
    if [ "$(ps | grep "dnsmasq" | wc -l)" -gt 1 ] ; then
        log -d dnsmasq "Dnsmasq is running."
    else
        log -e dnsmasq "Dnsmasq is not running."
        exit 1;
    fi
fi

exit 0;
