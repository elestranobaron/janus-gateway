# Utiliser Debian Trixie comme base
FROM debian:trixie-slim

# Éviter les invites interactives
ENV DEBIAN_FRONTEND=noninteractive

# Installer les dépendances nécessaires pour Janus
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    automake \
    autoconf \
    libtool \
    pkg-config \
    libglib2.0-dev \
    libjansson-dev \
    libnice-dev \
    libssl-dev \
    libsrtp2-dev \
    libwebsockets-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Cloner et compiler la dernière version de Janus
WORKDIR /janus-gateway
RUN git clone https://github.com/meetecho/janus-gateway.git . && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local --enable-websockets --disable-all-transports --enable-http --enable-websockets && \
    make && make install && make configs

# Configurer les permissions des fichiers de configuration
RUN chown -R root:root /usr/local/etc/janus && chmod -R 644 /usr/local/etc/janus

# Commande par défaut pour lancer Janus
CMD ["/usr/local/bin/janus", "-F", "/usr/local/etc/janus"]
