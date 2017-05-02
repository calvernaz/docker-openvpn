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
