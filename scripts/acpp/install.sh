#!/bin/bash

set -e
set -x

cd "$PIXI_PROJECT_ROOT"/build

cmake --install .
echo 'export PATH=/usr/local/acpp/bin:"$PATH"' >>/etc/profile.d/50-user-setup.sh
cp /build/acpp/pixi.toml /etc/project-manifests/cmake-project/pixi.toml

cd /
rm -rf build/acpp
rm -rf ~/.pixi
