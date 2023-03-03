set -e
cd /build/zlib
source /build/emsdk/emsdk_env.sh
emconfigure ./configure --static
emmake make -j4