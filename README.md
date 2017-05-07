# OpenVPN for Docker

_This repo is forked from kylemanna/docker-openvpn_

#### Upstream Links

* Docker Registry @ [cesaralvernaz/openvpn](https://hub.docker.com/r/cesaralvernaz/openvpn/)
* GitHub @ [calvernaz/docker-openvpn](https://github.com/calvernaz/docker-openvpn)

## Quick Start

* Pick a name for the `$OVPN_DATA` data volume container, it will be created automatically.

        OVPN_DATA="ovpn-data"

* Initialize the `$OVPN_DATA` container that will hold the configuration files and certificates

        docker volume create --name $OVPN_DATA
        docker run -v $OVPN_DATA:/etc/openvpn --rm cesaralvernaz/openvpn ovpn_genconfig -u udp://VPN.SERVERNAME.COM
        docker run -v $OVPN_DATA:/etc/openvpn --rm -it cesaralvernaz/openvpn ovpn_initpki

* Start OpenVPN server process

        docker run --privileged --name openvpn-server -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN cesaralvernaz/openvpn

* Generate a client certificate without a passphrase

        docker run -v $OVPN_DATA:/etc/openvpn --rm -it cesaralvernaz/openvpn easyrsa build-client-full CLIENTNAME nopass

* Retrieve the client configuration with embedded certificates

        docker run -v $OVPN_DATA:/etc/openvpn --rm cesaralvernaz/openvpn ovpn_getclient CLIENTNAME > CLIENTNAME.ovpn


## go-dnsmasq

Enables to reach clients by name, inside the directory `scripts` the `learn-address.sh` script scraps the client connection name
and prepends to an internal name (e.g client.internal.vpn).

Example:

    Sat May  6 20:05:01 2017 calvernaz/xx.xx.xx.187:7492 MULTI: Learn: 192.168.255.6 -> calvernaz/xx.xxx.xxx.187:7492
    Sat May  6 20:05:01 2017 calvernaz/xx.xx.xx.187:7492 MULTI: primary virtual IP for calvernaz/xx.xxx.xxx.187:7492: 192.168.255.6
    Sat May  6 20:05:04 2017 calvernaz/xx.xx.xx.187:7492 PUSH: Received control message: 'PUSH_REQUEST'
