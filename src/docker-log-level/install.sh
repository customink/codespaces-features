#!/bin/sh
set -e

echo "== [Custom Ink] installing 'docker-log-level' features ... =="

if [ ! "${CODESPACES}" = "true" ]; then
  echo "== [Custom Ink] detected CODESPACES=true =="
  sudo mkdir -p /etc/docker
  echo '{ "log-level": "warn" }' | sudo tee /etc/docker/daemon.json
else
  echo "== [Custom Ink] CODESPACES not detected in env. =="
  env
fi
