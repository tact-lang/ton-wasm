set -e

#
# Common parameters
#

source /build/emsdk/emsdk_env.sh
export CCACHE_DISABLE=1
export CC=$(which clang)
export CXX=$(which clang++)
export EMSDK_DIR=/build/emsdk
export ZLIB_DIR=/build/zlib
export OPENSSL_DIR=/build/openssl-es
rm -rf /build/ton/build
mkdir -p /build/ton/build
cd /build/ton/build

#
# Build
#

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
emmake make -j$(nproc) emulator-emscripten
emmake make -j$(nproc) funcfiftlib