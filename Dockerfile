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
COPY em-zlib.sh .
WORKDIR /build
RUN git clone --depth=1 https://github.com/madler/zlib.git
WORKDIR /build/zlib
RUN /bin/bash ../em-zlib.sh

#
# OpenSSL
#

WORKDIR /build
COPY em-openssl.sh .
WORKDIR /build
RUN git clone --depth=1 --branch OpenSSL_1_1_1j https://github.com/openssl/openssl.git
WORKDIR /build/openssl
RUN ./config && make -j4
RUN /bin/bash ../em-openssl.sh

#
# TON
#

RUN mkdir -p /build/ton
WORKDIR /build/ton
RUN git clone --recursive https://github.com/dvlkv/ton-blockchain.git .
RUN git checkout b0b6e5203f46d82b3a6c16037c5031746dc75193
WORKDIR /build
COPY em-ton.sh .

# 
# Compilator entry
#

WORKDIR /build
CMD ["/bin/bash", "/build/em-ton.sh"]