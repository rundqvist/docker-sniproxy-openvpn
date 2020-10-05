#!/bin/sh

if [ "$(var DNS_ENABLED)" = "true" ] && [ -z "$(var HOST_IP)" ]
then
    log -e "Environment variable 'HOST_IP' is mandatory if 'DNS_ENABLED=true. "
    exit 1;
elif [ "$(var DNS_ENABLED)" = "true" ]
then
    log -i "Dns server enabled.";
    cp -f /app/dnsmasq/supervisord.template.conf /app/dnsmasq/supervisord.conf

    echo "address=/#/$(var HOST_IP)" > /etc/dnsmasq.d/10-sniproxy.conf
else
    log -w "Dns server disabled."
    rm -f /app/dnsmasq/supervisord.conf
fi

exit 0;
