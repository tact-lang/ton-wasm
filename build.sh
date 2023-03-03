#!/bin/bash
set -e

# Build docker environment
docker build . -t ton-wasm-builder

# Export
rm -fr ./output
mkdir ./output
docker run -v "$(pwd)/output:/output" ton-wasm-builder