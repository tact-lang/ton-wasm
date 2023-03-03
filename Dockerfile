FROM ubuntu:20.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y build-essential git make cmake clang libgflags-dev zlib1g-dev libssl-dev libreadline-dev libmicrohttpd-dev pkg-config libgsl-dev python3 python3-dev python3-pip nodejs

#
# Emscripten
#

WORKDIR /build
RUN git clone https://github.com/emscripten-core/emsdk.git
WORKDIR /build/emsdk
RUN ./emsdk install 3.1.18 && ./emsdk activate 3.1.18

#
# ZLib
#

WORKDIR /build
RUN git clone --depth=1 https://github.com/madler/zlib.git /build/zlib
COPY build-zlib.sh .
RUN /bin/bash ./build-zlib.sh

#
# OpenSSL
#

WORKDIR /build
RUN git clone --depth=1 --branch OpenSSL_1_1_1j https://github.com/openssl/openssl.git /build/openssl
RUN git clone --depth=1 --branch OpenSSL_1_1_1j https://github.com/openssl/openssl.git /build/openssl-es
COPY build-openssl.sh .
RUN /bin/bash ./build-openssl.sh

#
# TON
#

RUN mkdir -p /build/ton
WORKDIR /build/ton
RUN git clone --recursive https://github.com/dvlkv/ton-blockchain.git .
RUN git checkout b0b6e5203f46d82b3a6c16037c5031746dc75193
WORKDIR /build
COPY ton-prepare.sh .
RUN /bin/bash ./ton-prepare.sh
COPY ton-build.sh .
RUN /bin/bash ./ton-build.sh
COPY ton-export.sh .

#
# Export
#

CMD ["/bin/bash", "./ton-export.sh"]