#!/bin/bash
set -e

# Build docker environment
docker build . -t ton-wasm-builder

# Prepare output directory
rm -fr ./output
mkdir ./output

# Build artifacts
docker run -v "${pwd}/output:/output" ton-wasm-builder