#!/bin/bash

if [ ! -d "Paper" ]; then
	echo "Paper directory does not exist. Run setup.sh first."
	exit -1
fi
if [ ! -d "Waterfall" ]; then
	echo "Waterfall directory does not exist. Run setup.sh first."
	exit -1
fi

cd Paper
echo "Applying paper-patches"
cd Paper-Server
for patch in ../../paper-patches/*.patch; do git apply $patch done
cd ..

echo "Applying paper-api-patches"
cd Paper-Api
for patch in ../../paper-api-patches/*.patch; do git apply $patch done
cd ..

echo "Rebuilding..."
mvn
cd ..

cd Waterfall
echo "Applying waterfall-patches"
cd Waterfall-Proxy
for patch in ../../waterfall-patches/*.patch; do git apply $patch done
cd ..

echo "MIMC | Building..."
echo ""
mvn

cd..
