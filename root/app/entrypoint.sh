#!/bin/sh

: ${COUNTRY:?"-e COUNTRY='...' missing"}
: ${USERNAME:?"-e USERNAME='...' missing"}
: ${PASSWORD:?"-e PASSWORD='...' missing"}

echo "$USERNAME" > /app/auth.conf
echo "$PASSWORD" >> /app/auth.conf

chmod 600 auth.conf

HOSTIP=$(wget http://api.ipify.org -O - -q)
RC=$?

echo $RC":"$HOSTIP > /app/hostip

#
# Make container accessible from private network
#
#if expr "${PNET}" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
#	route add -net ${PNET} netmask 255.255.255.0 gw $(route -n | grep 'UG[ \t]' | awk '{print $2}')
#fi

#
# Copy one config file
#
find /app/config/ -name "*${COUNTRY}*" -print | head -1 | xargs -I '{}' cp {} /app/config.ovpn

#
# Remove remote and verify-x509-name
#
sed -i '/remote /d' /app/config.ovpn
sed -i '/verify-x509-name /d' /app/config.ovpn

#
# Create list of allowed clients (and make sure it is not too long)
#
find /app/config/ -name "*${COUNTRY}*" -exec sed -n -e 's/^remote \(.*\) \(.*\)/\1/p' {} \; > /app/allowed-clients
echo "$(tail -n 32 allowed-clients)" > /app/allowed-clients

if [ ! -z "$PRIO_REMOTE" ]; then
	echo "[INFO] Setting "$PRIO_REMOTE" as prio remote"
	sed -i '/'$PRIO_REMOTE' /d' /app/allowed-clients
	sed -i '1s/^/'$PRIO_REMOTE'\n/' /app/allowed-clients
fi

#
# Add allowed clients as remotes
#
find /app/ -name "allowed-clients" -exec sed -n -e 's/^\(.*\)/remote \1 443/p' {} \; >> /app/config.ovpn

#
# Randomize
#
if [ "$RANDOMIZE" = "true" ]; then
	echo "[INFO] Randomizing remotes"
	echo 'remote-random' >>  /app/config.ovpn
fi

cp /etc/no-smart.conf /etc/dnsmasq.d/

exec supervisord -c /etc/supervisord.conf