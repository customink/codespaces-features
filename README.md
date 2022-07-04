[![Actions Status](https://github.com/customink/codespaces-features/workflows/Test/badge.svg)](https://github.com/customink/codespaces-features/actions) ![Codespaces](https://img.shields.io/badge/Codespaces-✅-black)

# Public Codespaces Features

⚠️ Eventually, all of these scripts will be used via the Codespaces' [container-features](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/container-features/README.md). Currently the features spec is under discussion here https://github.com/devcontainers/spec/issues/8 and till it is resolved, please download and execute each script using Codespaces' [lifecycle](https://code.visualstudio.com/docs/remote/devcontainerjson-reference#_lifecycle-scripts) hooks.

## Features & Usage

#### `common-amzn` - Common for Amazon Linux 2

Similar to the core [common](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/common.md) but instead of being limited to [debian](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/common-debian.sh), [redhat](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/common-redhat.sh), and [alpine](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/common-alpine.sh) this one works for Amazon Linux 2. This script is developed for AWS SAM's lambda build image, but should work for Amazon Linux 2 in general. Here is an example usage in a Node.js Lambda project.

```dockerfile
FROM public.ecr.aws/sam/build-nodejs16.x
# Codespaces development container.
ENV PATH /usr/sbin:$PATH
RUN curl -s https://raw.githubusercontent.com/customink/codespaces-features/main/common-amzn.sh | bash /dev/stdin 1> /dev/null
```

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
