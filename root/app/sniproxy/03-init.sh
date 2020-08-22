#!/bin/sh

mkdir -p /etc/sniproxy
cp -f /app/sniproxy/sniproxy.conf /etc/sniproxy/sniproxy.conf

echo "" >> /etc/supervisord.conf
cat /app/sniproxy/supervisord.conf >> /etc/supervisord.conf
