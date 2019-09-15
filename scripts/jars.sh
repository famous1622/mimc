#!/usr/bin/env bash

echo "[MIMC] Building Paper..."
echo ""
pushd Paper
./paper jar
popd

echo "[MIMC] Building Waterfall..."
echo ""
pushd Waterfall
./waterfall build
popd