#!/bin/sh
set -e

echo "== [Custom Ink] installing 'sam-cli' features ... =="

VERSION=${VERSION:-"latest"}

getFile() {
  case $1 in
    aarch64) echo "aws-sam-cli-linux-arm64.zip" ;;
    *)       echo "aws-sam-cli-linux-x86_64.zip" ;;
  esac
}

FILE=$(getFile $(uname -m))

if [ "${VERSION}" = "latest" ]; then
  DOWNLOAD_URL="https://github.com/aws/aws-sam-cli/releases/latest/download/${FILE}"
else
  DOWNLOAD_URL="https://github.com/aws/aws-sam-cli/releases/download/v${VERSION}/${FILE}"
fi

sudoIf() {
  if [ "$(id -u)" != 0 ]; then
    sudo "$@"
  else
    "$@"
  fi
}

cleanup() {
  rm -rf \
    install \
    ${FILE} \
    aws-sam-cli-src \
    dist \
    THIRD-PARTY-LICENSES
}

cd /tmp

cleanup

curl -sL "${DOWNLOAD_URL}" > $FILE
unzip -qq $FILE
sudoIf ./install --update

cleanup
