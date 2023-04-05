set -e
mkdir -p /output/wasm/
mkdir -p /output/js/
cp /build/output/deps.dot /output
cp /build/output/wasm/funcfiftlib.wasm \
   /build/output/wasm/funcfiftlib.js \
   /build/output/wasm/tlbc.wasm \
   /build/output/wasm/tlbc.js \
   /build/output/wasm/emulator-emscripten.wasm \
   /build/output/wasm/emulator-emscripten.js \
   /output/wasm
cp /build/output/js/emulator-emscripten.js \
   /output/js
cd /output/wasm

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