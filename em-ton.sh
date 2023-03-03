set -e

## Configuration
source /build/emsdk/emsdk_env.sh
export CCACHE_DISABLE=1
export OPENSSL_DIR=/build/openssl
export EMSDK_DIR=/build/emsdk
export ZLIB_DIR=/build/zlib
export CC=$(which clang)
export CXX=$(which clang++)

## Build
rm -rf /build/ton/build
mkdir -p /build/ton/build
cd /build/ton/build

## Prepare
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

## Run
emcmake cmake -DUSE_EMSCRIPTEN=ON \
              -DCMAKE_BUILD_TYPE=Release \
              -DZLIB_LIBRARY=$ZLIB_DIR/libz.a \
              -DZLIB_INCLUDE_DIR=$ZLIB_DIR \
              -DOPENSSL_ROOT_DIR=$OPENSSL_DIR \
              -DOPENSSL_INCLUDE_DIR=$OPENSSL_DIR/include \
              -DOPENSSL_CRYPTO_LIBRARY=$OPENSSL_DIR/libcrypto.a \
              -DOPENSSL_SSL_LIBRARY=$OPENSSL_DIR/libssl.a \
              -DCMAKE_TOOLCHAIN_FILE=$EMSDK_DIR/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake \
              -DCMAKE_CXX_FLAGS="-sUSE_ZLIB=1" \
              ..
cp -R ../crypto/smartcont ../crypto/fift/lib crypto
emmake make -j4 funcfiftlib

## Export
echo -n "module.exports = { FuncFiftLibWasm: '" > crypto/funcfiftlib.wasm.js
cat crypto/funcfiftlib.wasm | base64 --wrap=0 >> crypto/funcfiftlib.wasm.js
echo -n "' };" >> crypto/funcfiftlib.wasm.js
cp crypto/funcfiftlib.wasm crypto/funcfiftlib.js crypto/funcfiftlib.wasm.js /output