FROM debian:trixie-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    build-essential git automake autoconf libtool pkg-config \
    libglib2.0-dev libjansson-dev libnice-dev libssl-dev libsrtp2-dev \
    libwebsockets-dev libconfig-dev libusrsctp-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /janus-gateway
RUN git clone --single-branch --branch master https://github.com/meetecho/janus-gateway.git . && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local --enable-websockets --enable-data-channels --disable-all-transports --enable-http --enable-websockets && \
    make && make install && make configs
RUN chown -R root:root /usr/local/etc/janus && \
    chmod -R 644 /usr/local/etc/janus
CMD ["/usr/local/bin/janus", "-F", "/usr/local/etc/janus"]
