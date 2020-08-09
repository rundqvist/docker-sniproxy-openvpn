#!/bin/sh

VPNIP=$(wget http://api.ipify.org -O - -q)
RC=$?
HOSTIP=$(cat hostip)

if [ $RC -eq 1 ]; then
    echo "Failed to resolve VPN IP"
    exit 1;
fi

if [[ ${HOSTIP:0:1} = "1" ]]; then
    echo "Failed to resolve host IP"
    exit 1;
fi

if [ $RC":"$VPNIP = $HOSTIP ]; then
    echo "VPN IP same as host IP"
    exit 1;
fi

DATE_CURRENT=$(date +%d)
DATE_UPDATED=$(cat /app/date_updated)

if [ "$DATE_CURRENT" != "$DATE_UPDATED" ]; then

    echo "Updating vpn config" >> /var/log/healthcheck.log

    rm -f /app/config.zip

    wget -q https://www.ipvanish.com/software/configs/configs.zip -P /app/config/
    if [ $RC -eq 1 ]; then
        echo "Failed to download new config" >> /var/log/healthcheck.log
        exit 1;
    fi

    echo "Unzipping"  >> /var/log/healthcheck.log
	unzip /app/config/configs.zip -d /app/config
	mv /app/config/ca.ipvanish.com.crt .

    /app/configure-vpn.sh
    RC=$?
    if [ $RC -eq 1 ]; then
        echo "Failed to configure VPN" >> /var/log/healthcheck.log
        exit 1;
    fi

    echo $DATE_CURRENT > /app/date_updated

    #
    # Restart vpn
    #
    echo "Restarting"  >> /var/log/healthcheck.log
    killall -s HUP openvpn
fi

echo "Exiting"  >> /var/log/healthcheck.log
exit 0;
