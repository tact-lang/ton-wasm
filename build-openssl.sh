set -e

#
# Native
#

cd /build/openssl
./config
make -j4

#
# Wasm
#

cd /build/openssl-es
source /build/emsdk/emsdk_env.sh
emconfigure ./Configure linux-generic32 no-shared no-dso no-engine no-unit-test no-ui no-threads
sed -i 's/CROSS_COMPILE=.*/CROSS_COMPILE=/g' Makefile
sed -i 's/-ldl//g' Makefile
sed -i 's/-O3/-Os/g' Makefile
emmake make depend
emmake make -j4