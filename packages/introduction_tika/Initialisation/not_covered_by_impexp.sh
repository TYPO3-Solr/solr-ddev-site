#!/usr/bin/env bash

REQUIRED_TIKA_VERSION=$(composer --working-dir="packages/ext-tika" tika:req:tika)
TIKA_BINARY_APP="${TIKA_PATH}/tika-app-${REQUIRED_TIKA_VERSION}.jar"
TIKA_BINARY_SERVER="${TIKA_PATH}/tika-server-${REQUIRED_TIKA_VERSION}.jar"

if [[ ! -f "${TIKA_BINARY_APP}" ]]; then
  echo "Required for integration tests ${TIKA_BINARY_APP} file does not exist on system."
  echo "downloading ... "
  composer --working-dir="packages/ext-tika" tika:download:app -- -C -D "${TIKA_PATH}"
fi

if [[ ! -f "${TIKA_BINARY_SERVER}" ]]; then
  echo "Required for clicky-bunty tests ${TIKA_BINARY_SERVER} file does not exist on system."
  echo "downloading ... "
  composer --working-dir="packages/ext-tika" tika:download:server -- -C -D "${TIKA_PATH}"
fi

