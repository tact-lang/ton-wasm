set -e
cd /build/ton/build/crypto
cp funcfiftlib.wasm funcfiftlib.js tlbc.wasm tlbc.js /output/
cd /build/ton/build/emulator
cp emulator-emscripten.wasm emulator-emscripten.js /output/
cd /output/

# Create emulator-emscripten.wasm.js
echo -n "module.exports = { wasmBinary: '" > emulator-emscripten.wasm.js
cat emulator-emscripten.wasm | base64 --wrap=0 >> emulator-emscripten.wasm.js
echo -n "' };" >> emulator-emscripten.wasm.js

# Create funcfiftlib.wasm.js
echo -n "module.exports = { wasmBinary: '" > funcfiftlib.wasm.js
cat funcfiftlib.wasm | base64 --wrap=0 >> funcfiftlib.wasm.js
echo -n "' };" >> funcfiftlib.wasm.js

# Create tlbc.wasm.js
echo -n "module.exports = { wasmBinary: '" > tlbc.wasm.js
cat tlbc.wasm | base64 --wrap=0 >> tlbc.wasm.js
echo -n "' };" >> tlbc.wasm.js