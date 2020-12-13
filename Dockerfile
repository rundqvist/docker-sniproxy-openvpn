FROM rundqvist/openvpn:1.2

LABEL maintainer="mattias.rundqvist@icloud.com"

WORKDIR /app

COPY root /

ENV DNS_ENABLED=''

RUN apk add --update --no-cache sniproxy dnsmasq

EXPOSE 53 80 443
