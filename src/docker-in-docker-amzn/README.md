
# Docker-in-Docker Amazon Linux 2 (docker-in-docker-amzn)

Like [Docker-in-Docker (docker-in-docker](https://github.com/devcontainers/features/tree/main/src/docker-in-docker) but for Amazon Linux 2.

## Example Usage

```json
"features": {
  "ghcr.io/customink/codespaces-features/docker-in-docker-amzn:latest": {}
},
"runArgs": ["--init", "--privileged"],
"overrideCommand": false
```

Add to your dev/build `Dockerfile`.

```dockerfile
ENV PATH="/usr/sbin:${PATH}"
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]
VOLUME [ "/var/lib/docker" ]
```

## Options

None at this time.
