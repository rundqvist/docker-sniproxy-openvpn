FROM rundqvist/openvpn:latest

LABEL maintainer="mattias.rundqvist@icloud.com"

WORKDIR /app

COPY root /

RUN apk add --update --no-cache sniproxy \
	&& chmod 755 /app/sniproxy/init.sh \
	&& chmod 755 /app/healthcheck.sh \
	&& chmod 755 /app/entrypoint.sh

EXPOSE 80 443

#HEALTHCHECK --interval=30s --timeout=60s --start-period=15s \  
# CMD /bin/sh /app/healthcheck.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]