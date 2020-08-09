#!/bin/sh

: ${USERNAME:?"-e USERNAME='...' missing"}
: ${PASSWORD:?"-e PASSWORD='...' missing"}
: ${COUNTRY:?"-e COUNTRY='...' missing"}

#
# Create auth file
#
echo "$USERNAME" > /app/auth.conf
echo "$PASSWORD" >> /app/auth.conf
chmod 600 auth.conf

#
# Store host ip before starting vpn
#
HOSTIP=$(wget http://api.ipify.org -O - -q)
RC=$?

echo $RC":"$HOSTIP > /app/hostip

/app/configure-vpn.sh

exec supervisord -c /etc/supervisord.conf

