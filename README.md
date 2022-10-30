[![Actions Status](https://github.com/customink/codespaces-features/workflows/Test/badge.svg)](https://github.com/customink/codespaces-features/actions) ![Codespaces](https://img.shields.io/badge/Codespaces-✅-black)

## Features & Usage

#### Amazon Linux 2

All Amazon Linux 2 features are similar to their [vscode-dev-containers](https://github.com/microsoft/vscode-dev-containers/tree/main/script-library/docs) counterparts. Instead of being limited to [debian](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/common-debian.sh), [redhat](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/common-redhat.sh), and [alpine](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/common-alpine.sh) ours work for Amazon Linux 2. This script is developed for AWS SAM's lambda build image, but should work for Amazon Linux 2 in general. Examples below use SAM's Node.js Lambda build image.

* [Common Amazon Linux 2 Utilities (common-amzn)](/src/common-amzn)
* [Docker-in-Docker Amazon Linux 2 (docker-in-docker-amzn)](/src/docker-in-docker-amzn)

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
