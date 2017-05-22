FROM alpine:3.5

LABEL maintainer "cesar.alvernaz@gmail.com"

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update openvpn iptables bash easy-rsa openvpn-auth-pam google-authenticator pamtester && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

ADD https://github.com/janeczku/go-dnsmasq/releases/download/1.0.7/go-dnsmasq-min_linux-amd64 /usr/local/bin

# Needed by scripts
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/share/easy-rsa
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars

# go dnsmasq
ENV DNSMASQ_DEFAULT true
ENV DNSMASQ_SERVERS 192.168.255.1
ENV DNSMASQ_HOSTSFILE /etc/hosts.vpn-clients
ENV DNSMASQ_POLL 30
ENV DNSMASQ_SEARCH_DOMAINS internal.vpn.livesense.au
ENV DNSMASQ_ENABLE_SEARCH true


VOLUME ["/etc/openvpn"]

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/udp

ADD ./bin /usr/local/bin

RUN chmod a+x /usr/local/bin/* 

RUN touch /etc/hosts.vpn-clients && \
    chown nobody:nobody /etc/hosts.vpn-clients

ADD ./scripts /etc/openvpn
ADD ./otp/openvpn /etc/pam.d/

CMD ["ovpn_run"]
