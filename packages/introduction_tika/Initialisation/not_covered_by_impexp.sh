#!/usr/bin/env bash

REQUIRED_TIKA_VERSION=$(composer --working-dir="packages/ext-tika" tika:req:tika)
TIKA_BINARY_APP="${TIKA_PATH}/tika-app-${REQUIRED_TIKA_VERSION}.jar"

if [[ ! -f "${TIKA_BINARY_APP}" ]]; then
  echo "Required for integration tests ${TIKA_BINARY_APP} file does not exist on system."
  echo "downloading ... "
  composer --working-dir="packages/ext-tika" tika:download -- -C -D "${TIKA_PATH}"
fi
