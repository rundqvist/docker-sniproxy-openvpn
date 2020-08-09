#!/bin/sh

: ${USERNAME:?"-e USERNAME='...' missing"}
: ${PASSWORD:?"-e PASSWORD='...' missing"}
: ${COUNTRY:?"-e COUNTRY='...' missing"}

echo "$USERNAME" > /app/auth.conf
echo "$PASSWORD" >> /app/auth.conf

chmod 600 auth.conf

HOSTIP=$(wget http://api.ipify.org -O - -q)
RC=$?

echo $RC":"$HOSTIP > /app/hostip

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
# Create list of allowed remotes
#
find /app/config/ -name "*${COUNTRY}*" -exec sed -n -e 's/^remote \(.*\) \(.*\)/\1/p' {} \; | sort > /app/all.remotes

if [ $INCLUDED_REMOTES != '' ]; then

    for s in $INCLUDED_REMOTES ; do
        echo $s
    done | sort > /app/included.remotes

    comm /app/all.remotes /app/included.remotes -12 > /app/tmp.remotes  
    rm -f /app/included.remotes
    mv -f /app/tmp.remotes /app/all.remotes
    
fi

if [ $EXCLUDED_REMOTES != '' ]; then

    for s in $EXCLUDED_REMOTES ; do
        echo $s
    done | sort > /app/excluded.remotes

    comm /app/all.remotes /app/excluded.remotes -23 > /app/tmp.remotes  
    rm -f /app/excluded.remotes
    mv -f /app/tmp.remotes /app/all.remotes
    
fi

#
#  Make sure list is not too long
#
echo "$(tail -n 32 all.remotes)" > /app/all.remotes

#
# Add allowed remotes as remotes
#
find /app/ -name "all.remotes" -exec sed -n -e 's/^\(.*\)/remote \1 443/p' {} \; >> /app/config.ovpn

#
# Randomize
#
#echo 'remote-random' >>  /app/config.ovpn

exec supervisord -c /etc/supervisord.conf

