#!/bin/bash
set -e

# Build docker environment
docker build . --platform linux/amd64 -t ton-wasm-builder

# Export
rm -fr ./output
mkdir ./output
docker run --platform linux/amd64 -v "$(pwd)/output:/output" ton-wasm-builder