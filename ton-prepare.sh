set -e
export CCACHE_DISABLE=1
export CC=$(which clang)
export CXX=$(which clang++)
export EMSDK_DIR=/build/emsdk
export ZLIB_DIR=/build/zlib
export OPENSSL_DIR=/build/openssl
rm -rf /build/ton/build
mkdir -p /build/ton/build
cd /build/ton/build
cmake -DCMAKE_BUILD_TYPE=Release \
      -DZLIB_LIBRARY=/usr/lib/x86_64-linux-gnu/libz.so \
      -DZLIB_INCLUDE_DIR=$ZLIB_DIR \
      -DOPENSSL_ROOT_DIR=$OPENSSL_DIR \
      -DOPENSSL_INCLUDE_DIR=$OPENSSL_DIR/include \
      -DOPENSSL_CRYPTO_LIBRARY=$OPENSSL_DIR/libcrypto.so \
      -DOPENSSL_SSL_LIBRARY=$OPENSSL_DIR/libssl.so \
      ..
make -j4 fift
rm -rf /build/ton/build/*