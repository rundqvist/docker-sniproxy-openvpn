# Docker OpenVPN container with SNI Proxy
A small container for proxying http(s)-traffic through vpn.

[![Docker pulls](https://img.shields.io/docker/pulls/rundqvist/openvpn-sniproxy.svg)](https://hub.docker.com/r/rundqvist/openvpn-sniproxy)

## Do you find this container useful? 
Please support the development by making a small donation.

[![Support](https://img.shields.io/badge/support-Flattr-brightgreen)](https://flattr.com/@rundqvist)
[![Support](https://img.shields.io/badge/support-Buy%20me%20a%20coffee-orange)](https://www.buymeacoffee.com/rundqvist)
[![Support](https://img.shields.io/badge/support-PayPal-blue)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=SZ7J9JL9P5DGE&source=url)

## Features
* Killswitch (kills network if vpn is down)
* Proxies all http(s)-traffic through vpn

## Requirements
* A local DNS server (or at least, ability to configure your DNS lookups)
* Ports 80 & 443 available on host
* A supported VPN account (currently [IPVanish](https://www.ipvanish.com/?a_bid=48f95966&a_aid=5f3eb2f0be07f) or [WeVPN](https://www.wevpn.com/aff/rundqvist))

[![Sign up](https://img.shields.io/badge/sign_up-IPVanish_VPN-6fbc44)](https://www.ipvanish.com/?a_bid=48f95966&a_aid=5f3eb2f0be07f)
[![Sign up](https://img.shields.io/badge/sign_up-WeVPN-e33866)](https://www.wevpn.com/aff/rundqvist)

## Components
* Alpine Linux
* OpenVPN container as base (https://hub.docker.com/r/rundqvist/openvpn)
* SNI Proxy (https://github.com/dlundquist/sniproxy)
* Dnsmasq

## Run
```
$ sudo docker run \
    -d \
    --cap-add=NET_ADMIN \
    --device=/dev/net/tun \
    --name=openvpn-sniproxy \
    --dns 1.1.1.1 \
    --dns 1.0.0.1 \
    -p 53:53/udp \
    -p 80:80 \
    -p 443:443 \
    -e 'HOST_IP=[your server ip]' \
    -e 'VPN_PROVIDER=[your vpn provider]' \
    -e 'VPN_USERNAME=[your vpn username]' \
    -e 'VPN_PASSWORD=[your vpn password]' \
    -e 'VPN_COUNTRY=[your desired country]' \
    -e 'DNS_ENABLED=true' \
    rundqvist/openvpn-sniproxy
```

### Configuration
See base image for vpn configuration: https://hub.docker.com/r/rundqvist/openvpn

| Variable | Usage |
|----------|-------|
| HOST_IP | IP of the machine where container is running. |
| DNS_ENABLED | Enables DNS server in container to easier route http(s)-requests through vpn. |

## Setup
Enable DNS in container, or configure your DNS to return your host ip for all lookups.

Example (if your DNS utilizes dnsmasq):
* Locate your dnsmasq folder (usually /etc/dnsmasq.d/)
* Create a _.conf_ file (for example: 10-proxy.conf)
* Add the following contents to the file:

``` 
address=/#/[your server ip]
```
* Restart DNS

## Issues
Please report issues at https://github.com/rundqvist/docker-openvpn-sniproxy/issues
