#!/bin/bash

set -e
set -x

cd "$PIXI_PROJECT_ROOT"/build

cmake --build .
