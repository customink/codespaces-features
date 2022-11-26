#!/bin/sh
set -e

echo "== [Custom Ink] installing 'sam-cli' features ... =="

VERSION=${VERSION:-"latest"}

if [ "${VERSION}" = "latest" ]; then
  DOWNLOAD_URL="https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip"
else
  DOWNLOAD_URL="https://github.com/aws/aws-sam-cli/releases/download/v${VERSION}/aws-sam-cli-linux-x86_64.zip"
fi

sudoIf() {
  if [ "$(id -u)" != 0 ]; then
    sudo "\$@"
  else
    "\$@"
  fi
}

cleanup() {
  rm -rf \
    install \
    aws-sam-cli-linux-x86_64.zip \
    aws-sam-cli-src \
    dist \
    THIRD-PARTY-LICENSES
}

cd /tmp

cleanup

curl -sL "${DOWNLOAD_URL}" > "aws-sam-cli-linux-x86_64.zip"
unzip -qq "aws-sam-cli-linux-x86_64.zip"
sudoIf ./install --update

cleanup
