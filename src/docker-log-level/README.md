
# Set Docker Log Level (docker-log-level)

Sets the docker log-level (https://docs.docker.com/config/daemon/logs/) to warn by creating a  `/etc/docker/daemon.json` file. 

## Example Usage

```json
"features": {
  "ghcr.io/customink/codespaces-features/docker-log-level": {}
}
```

## Options

| Options Id | Description                  | Type   | Default Value |
|------------|------------------------------|--------|---------------|
| level      | Select the Docker log-level. | string | warn          |
