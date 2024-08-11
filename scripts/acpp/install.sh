#!/bin/bash

set -e
set -x

cd "$PIXI_PROJECT_ROOT"/build

cmake --install .
mkdir -p /etc/project-manifests/acpp-project
cp /build/acpp/pixi.toml /etc/project-manifests/acpp-project/pixi.toml
cat /build/acpp/scripts/pixi.toml.append | tee -a /etc/project-manifests/acpp-project/pixi.toml

cd /
rm -rf build/acpp
rm -rf ~/.pixi
