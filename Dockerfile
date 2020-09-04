FROM rundqvist/openvpn:latest

LABEL maintainer="mattias.rundqvist@icloud.com"

WORKDIR /app

COPY root /

ENV NETWORK=''

RUN apk add --update --no-cache sniproxy

EXPOSE 80 443
