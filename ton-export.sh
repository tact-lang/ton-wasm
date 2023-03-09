set -e
cd /build/ton/build/crypto
cp funcfiftlib.wasm funcfiftlib.js tlbc.wasm tlbc.js /output/
cd /build/ton/build/emulator
cp emulator-emscripten.wasm emulator-emscripten.js /output/