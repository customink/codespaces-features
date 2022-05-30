[![Actions Status](https://github.com/customink/codespaces-features/workflows/Test/badge.svg)](https://github.com/customink/codespaces-features/actions) ![Codespaces](https://img.shields.io/badge/Codespaces-✅-black)

# Public Codespaces Features

⚠️ Eventually, all of these scripts will be used via the Codespaces' [container-features](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/container-features/README.md). Currently the features spec is under discussion here https://github.com/devcontainers/spec/issues/8 and till it is resolved, please download and execute each script using Codespaces' [lifecycle](https://code.visualstudio.com/docs/remote/devcontainerjson-reference#_lifecycle-scripts) hooks.

## Testing & Development

If you want to run the tests locally, this command should work.

```shell
./bin/test
```

Need some interactive feedback? Use the `bin/console` script to load up an image with this directory shared in `/var/task`. The last argument is any image name:tag.

```shell
$ ./bin/console \
  public.ecr.aws/sam/build-nodejs16.x
```
