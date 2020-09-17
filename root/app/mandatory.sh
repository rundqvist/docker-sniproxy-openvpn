#!/bin/sh

for var in "VPN_PROVIDER" "VPN_USERNAME" "VPN_PASSWORD" "VPN_COUNTRY" ; do 

    if [ -z "$(var $var)" ] ; then
        log -e sniproxy "Environment variable '$var' is mandatory. "
        var abort true
    else
        log -d sniproxy "Mandatory variable '$var' is ok."
    fi

done

if [ "$(var DNS_ENABLED)" = "true" ] && [ -z "$(var HOST_IP)" ] ; then
    log -e sniproxy "Environment variable 'HOST_IP' is mandatory if 'DNS_ENABLED=true. "
    var abort true
fi

if [ "$(var abort)" = "true" ] ; then
    exit 1;
fi
exit 0;
