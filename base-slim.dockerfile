FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        iproute2 \
        iptables \
        openvpn \
        procps \
        psmisc \
        python3 \
    && rm -rf /var/lib/apt/lists/*