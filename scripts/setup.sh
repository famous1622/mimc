#!/usr/bin/env bash

if [ -d "Paper" ]; then
	echo "MIMC | Paper directory exists. For a clean setup remove Paper and Waterfall folder."
	exit -1
fi
if [ -d "Waterfall" ]; then
	echo "MIMC | Waterfall directory exists. For a clean setup remove Paper and Waterfall folder."
	exit -1
fi

echo "[MIMC] Cloning Paper..."
echo ""

git clone https://github.com/PaperMC/Paper.git
pushd Paper
git checkout ver/1.14

echo "[MIMC] Patching Paper..."
./paper p
popd

echo "[MIMC] Cloning Waterfall..."
echo ""
git clone https://github.com/PaperMC/Waterfall.git
pushd Waterfall
echo "[MIMC] Patching Waterfall..."
./waterfall p
popd

./scripts/buildPlugins.sh

echo "[MIMC] Copying over Paper configuration defaults..."
echo ""
pushd Paper
mkdir -p work/test-server/plugins
cp ../paper-plugins/info/target/info-1.0-SNAPSHOT.jar work/test-server/plugins/
cp ../paper-plugins/migrate/mimc.migrate.jar work/test-server/plugins/
cp ../paper-plugins/btlp/BTLPPaper.jar work/test-server/plugins/
cp ../config/Paper/* work/test-server/

popd
pushd Waterfall
mkdir -p work/plugins
cp ../waterfall-plugins/BTLPBungee.jar work/plugins/
cp ../waterfall-plugins/MIMCBungee.jar work/plugins/


