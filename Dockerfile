FROM alpine:3.12

LABEL maintainer="mattias.rundqvist@icloud.com"

WORKDIR /app

COPY root /

RUN apk add --update --no-cache supervisor openvpn sniproxy \
	&& mkdir /app/config \
	&& wget https://www.ipvanish.com/software/configs/configs.zip -P /app/config/ \
	&& unzip /app/config/configs.zip -d /app/config \
	&& mv /app/config/ca.ipvanish.com.crt . \
	&& chmod 755 /app/tls-verify.sh \
	&& chmod 755 /app/configure-vpn.sh \
	&& chmod 755 /app/healthcheck.sh \
	&& chmod 755 /app/entrypoint.sh

ENV COUNTRY='' \
	USERNAME='' \
	PASSWORD='' \
	INCLUDED_REMOTES='' \
	EXCLUDED_REMOTES=''

EXPOSE 80 443

HEALTHCHECK --interval=30s --timeout=60s --start-period=15s \  
 CMD /bin/sh /app/healthcheck.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]