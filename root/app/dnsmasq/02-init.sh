#!/bin/sh

if [ "$(var DNS_ENABLED)" = "true" ] ; then
    log -i dnsmasq "DNS server enabled.";
    cp -f /app/dnsmasq/supervisord.template.conf /app/dnsmasq/supervisord.conf

    echo "address=/#/$(var HOST_IP)" > /etc/dnsmasq.d/10-sniproxy.conf
else
    log -w dnsmasq "DNS server disabled."
    rm -f /app/dnsmasq/supervisord.conf
fi