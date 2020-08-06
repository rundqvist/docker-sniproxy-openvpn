#!/bin/sh

if [ -z "$COUNTRY" ]
then

    echo "[INFO] Country is empty. Container acting as proxy only."

    exec supervisord -c /etc/supervisord-proxy.conf

else

    : ${USERNAME:?"-e USERNAME='...' missing"}
    : ${PASSWORD:?"-e PASSWORD='...' missing"}

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
    # Create list of allowed clients (and make sure it is not too long)
    #
    find /app/config/ -name "*${COUNTRY}*" -exec sed -n -e 's/^remote \(.*\) \(.*\)/\1/p' {} \; > /app/allowed-clients
    echo "$(tail -n 32 allowed-clients)" > /app/allowed-clients

    #
    # Add allowed clients as remotes
    #
    find /app/ -name "allowed-clients" -exec sed -n -e 's/^\(.*\)/remote \1 443/p' {} \; >> /app/config.ovpn

    #
    # Randomize
    #
    #echo 'remote-random' >>  /app/config.ovpn

    exec supervisord -c /etc/supervisord-vpn.conf
fi
