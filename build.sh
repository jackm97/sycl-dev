#!/bin/bash

set -x
set -e

container_build=$1
date=$(date '+%Y-%m-%d')

rm -rf builddir/acpp
mkdir -p builddir

# Build
$container_build build . -v $PWD/builddir:/build:z --file Containerfile --target acpp-base -t ghcr.io/jackm97/sycl-dev:acpp-base_"$date"
$container_build build . -v $PWD/builddir:/build:z --file Containerfile --target sycl-dev:acpp-rocky -t ghcr.io/jackm97/sycl-dev:acpp-rocky_"$date"
$container_build build . -v $PWD/builddir:/build:z --file Containerfile --target sycl-dev:acpp-ubu -t ghcr.io/jackm97/sycl-dev:acpp-ubu_"$date"

# Tag
$container_build tag ghcr.io/jackm97/sycl-dev:acpp-base_"$date" ghcr.io/jackm97/sycl-dev:acpp-base

$container_build tag ghcr.io/jackm97/sycl-dev:acpp-rocky_"$date" ghcr.io/jackm97/sycl-dev:acpp-rocky
$container_build tag ghcr.io/jackm97/sycl-dev:acpp-rocky ghcr.io/jackm97/sycl-dev:acpp-rocky-latest
$container_build tag ghcr.io/jackm97/sycl-dev:acpp-rocky ghcr.io/jackm97/sycl-dev:latest

$container_build tag ghcr.io/jackm97/sycl-dev:acpp-ubu_"$date" ghcr.io/jackm97/sycl-dev:acpp-ubu
$container_build tag ghcr.io/jackm97/sycl-dev:acpp-ubu ghcr.io/jackm97/sycl-dev:ubu-latest

# Push
$container_build push ghcr.io/jackm97/sycl-dev:acpp-base_"$date"
$container_build push ghcr.io/jackm97/sycl-dev:acpp-base

$container_build push ghcr.io/jackm97/sycl-dev:acpp-rocky_"$date"
$container_build push ghcr.io/jackm97/sycl-dev:acpp-rocky
$container_build push ghcr.io/jackm97/sycl-dev:acpp-rocky-latest
$container_build push ghcr.io/jackm97/sycl-dev:latest

$container_build push ghcr.io/jackm97/sycl-dev:acpp-ubu_"$date"
$container_build push ghcr.io/jackm97/sycl-dev:acpp-ubu
$container_build push ghcr.io/jackm97/sycl-dev:ubu-latest
