# Docker OpenVPN container with SNI Proxy
A small container for proxying http(s)-traffic through vpn.

[![Docker pulls](https://img.shields.io/docker/pulls/rundqvist/sniproxy-openvpn.svg)](https://hub.docker.com/r/rundqvist/sniproxy-openvpn)
[![image size](https://img.shields.io/docker/image-size/rundqvist/sniproxy-openvpn.svg)](https://hub.docker.com/r/rundqvist/sniproxy-openvpn)
[![commit activity](https://img.shields.io/github/commit-activity/m/rundqvist/docker-sniproxy-openvpn)](https://github.com/rundqvist/docker-sniproxy-openvpn)
[![last commit](https://img.shields.io/github/last-commit/rundqvist/docker-sniproxy-openvpn.svg)](https://github.com/rundqvist/docker-sniproxy-openvpn)

## Features
* Killswitch (kills network if vpn is down)
* Proxies all http(s)-traffic through vpn
* Self healing (restarts vpn if connection breaks down)
* Built in dns server
* Connect to random server
* Healthcheck (checking that ip differs from public ip)

## Requirements
* Ports 80 & 443 available on host
* A supported VPN account.

[![Sign up](https://img.shields.io/badge/sign_up-IPVanish_VPN-6fbc44)](https://www.ipvanish.com/?a_bid=48f95966&a_aid=5f3eb2f0be07f)
[![Sign up](https://img.shields.io/badge/sign_up-Ivacy_VPN-3dacf3)](https://www.ivacy.com/get-30-days-free-vpn/?refer=802326)
[![Sign up](https://img.shields.io/badge/sign_up-WeVPN-e33866)](https://www.wevpn.com/aff/rundqvist)

## Components
Built on [rundqvist/openvpn](https://hub.docker.com/r/rundqvist/openvpn) container.
* [Alpine Linux](https://www.alpinelinux.org)
* [Supervisor](https://github.com/Supervisor/supervisor)
* [OpenVPN](https://github.com/OpenVPN/openvpn)
* [SNI Proxy](https://github.com/dlundquist/sniproxy)
* [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)

## Run
```
$ sudo docker run \
    -d \
    --cap-add=NET_ADMIN \
    --device=/dev/net/tun \
    --name=sniproxy-openvpn \
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
    -v /path/to/cache/folder:/cache/ \
    rundqvist/sniproxy-openvpn
```

### Configuration
See base image ([rundqvist/openvpn](https://hub.docker.com/r/rundqvist/openvpn)) for detailed vpn configuration.

#### Variables
| Variable | Usage |
|----------|-------|
| HOST_IP | IP of the machine where container is running. |
| DNS_ENABLED | Enables DNS server in container to easier route http(s)-requests through vpn. <br />`true` or `false` (default). |
| _VPN_PROVIDER_ | Supported providers:<br />- [ipvanish](https://www.ipvanish.com/?a_bid=48f95966&a_aid=5f3eb2f0be07f)<br />- [ivacy](https://www.ivacy.com/get-30-days-free-vpn/?refer=802326)<br />- [wevpn](https://www.wevpn.com/aff/rundqvist) |
| _VPN_USERNAME_ | Your VPN username. |
| _VPN_PASSWORD_ | Your VPN password. |
| _VPN_COUNTRY_ | ISO 3166-1 alpha-2 country code (https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2). |
| VPN_KILLSWITCH | Kills network if vpn is down. <br />`true` (default) or `false`. |
| VPN_INCLUDED_REMOTES | Host names separated by one space. VPN will _only_ connect to entered remotes. |
| VPN_EXCLUDED_REMOTES | Host names separated by one space. VPN will _not_ connect to entered remotes. |
| VPN_REMOTES_FILTER_MODE | If set, included/excluded-filtering of remotes resulting in an empty list will cause vpn to not connect. <br />`strict`, `strict-included` or `strict-excluded`. |
| VPN_RANDOM_REMOTE | Connects to random remote. <br />`true` or `false` (default). |

Variables in _cursive_ is mandatory.

#### Volumes

| Folder | Usage |
|--------|-------|
| /cache/ | Used for caching original configuration files from vpn provider |

## Setup

### Internal DNS
Set `DNS_ENABLED=true` and configure your client (or router) to use `HOST_IP` as DNS.

### External DNS
Configure your DNS to return your host ip for all lookups.

Example (if your DNS utilizes dnsmasq):
* Locate your dnsmasq folder (usually /etc/dnsmasq.d/)
* Create a _.conf_ file (for example: 10-proxy.conf)
* Add the following contents to the file (replace `HOST_IP` with your actual IP):

``` 
address=/#/[HOST_IP]
```
* Restart DNS

## Issues
Please report issues at https://github.com/rundqvist/docker-sniproxy-openvpn/issues

## Donations
Please support the development by making a small donation.

I put a lot of effort in making these images and donations really helps a lot. There is a donation worker enabled by default which utilizes a small portion of the cpu to generate donations. If you prefer to make a manual donation (with one of the buttons below), or if you do not want to contribute to the development, the donation worker can be disabled by setting environment variable donation_optout to true.

[![Support](https://img.shields.io/badge/support-Flattr-brightgreen)](https://flattr.com/@rundqvist)
[![Support](https://img.shields.io/badge/support-Buy%20me%20a%20coffee-orange)](https://www.buymeacoffee.com/rundqvist)
[![Support](https://img.shields.io/badge/support-PayPal-blue)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=SZ7J9JL9P5DGE&source=url)

