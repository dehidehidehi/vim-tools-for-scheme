#!/bin/bash

set -a
source ../.env
set +a
wget "$AKKU_DOWNLOAD_URL" -O "$TMP_DIR/akku-$AKKU_VERSION.tar.xz"
tar -xJf "$TMP_DIR/akku-$AKKU_VERSION.tar.xz" -C "$TMP_DIR"
(cd "$TMP_DIR/akku-$AKKU_VERSION.amd64-linux" && ./install.sh)
akku update
