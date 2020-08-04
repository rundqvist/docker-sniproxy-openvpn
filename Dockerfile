FROM alpine:3.12

LABEL maintainer="mattias.rundqvist@icloud.com"

WORKDIR /app

COPY root /

RUN apk add --update --no-cache supervisor openvpn sniproxy \
	&& mkdir config \
	&& wget https://www.ipvanish.com/software/configs/configs.zip -P config/ \
	&& unzip config/configs.zip -d config \
	&& mv config/ca.ipvanish.com.crt . \
	&& chmod 755 tls-verify.sh \
	&& chmod 755 entrypoint.sh

ENV COUNTRY='NL' \
	USERNAME='' \
	PASSWORD='' \
	PNET='' \
	RANDOMIZE='true' \
	PRIO_REMOTE=''

EXPOSE 80 443

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s \  
 CMD /bin/sh /app/healthcheck.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]