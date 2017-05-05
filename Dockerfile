FROM debian:jessie-slim

LABEL maintainer "cesar.alvernaz@gmail.com"

RUN apt-get update && \
    apt-get install -y openvpn iptables easy-rsa dnsmasq ipcalc socat && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Needed by scripts
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/share/easy-rsa
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars

VOLUME ["/etc/openvpn"]

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/udp

CMD ["ovpn_run"]

RUN systemctl enable dnsmasq

ADD ./bin /usr/local/bin
ADD ./scripts /etc/openvpn
