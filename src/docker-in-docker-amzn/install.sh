#!/usr/bin/env bash
# 
# Copied From: https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docker-in-docker-debian.sh
# 
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Docs: https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/docker-in-docker.md
# Maintainer: The VS Code and Codespaces Teams
#
# Syntax: ./docker-in-docker-debian.sh [enable non-root docker access flag] [non-root user]

set -e

echo "== [Custom Ink] installing 'docker-in-docker-amzn' features ... =="

ENABLE_NONROOT_DOCKER=${1:-"true"}
USERNAME=${2:-"automatic"}

# Setup STDERR.
err() {
    echo "== [Custom Ink] (!) $* ==" >&2
}

if [ "$(id -u)" -ne 0 ]; then
    err 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

###################
# Helper Functions
# See: https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/shared/utils.sh
###################

# Determine the appropriate non-root user
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in ${POSSIBLE_USERS[@]}; do
        if id -u ${CURRENT_USER} > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} > /dev/null 2>&1; then
    USERNAME=root
fi

###########################################
# Start docker-in-docker installation
###########################################

# Source /etc/os-release to get OS info
. /etc/os-release

# Install Docker if not already installed
if type docker > /dev/null 2>&1 && type dockerd > /dev/null 2>&1; then
    echo "== [Custom Ink] Docker already installed. =="
else
    yum install -y amazon-linux-extras && \
      amazon-linux-extras enable docker && \
      yum install -y docker
fi

if type /usr/sbin/iptables-legacy > /dev/null 2>&1; then
    /usr/sbin/update-alternatives --set iptables /usr/sbin/iptables-legacy
    /usr/sbin/update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy || true
fi

echo "== [Custom Ink] Finished installing docker! =="

# If init file already exists, exit
if [ -f "/usr/local/share/docker-init.sh" ]; then
    echo "== [Custom Ink] /usr/local/share/docker-init.sh already exists, so exiting. =="
    exit 0
fi
echo "== [Custom Ink] docker-init doesnt exist, adding... =="

# Add user to the docker group
if [ "${ENABLE_NONROOT_DOCKER}" = "true" ]; then
    if ! /usr/bin/getent group docker > /dev/null 2>&1; then
        /usr/sbin/groupadd docker
    fi
    /usr/sbin/usermod -aG docker ${USERNAME}
fi

tee /usr/local/share/docker-init.sh > /dev/null \
<< 'EOF'
#!/bin/sh
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
set -e
dockerd_start="$(cat << 'INNEREOF'
    # explicitly remove dockerd and containerd PID file to ensure that it can start properly if it was stopped uncleanly
    # ie: docker kill <ID>
    find /run /var/run -iname 'docker*.pid' -delete || :
    find /run /var/run -iname 'container*.pid' -delete || :
    ## Dind wrapper script from docker team, adapted to a function
    # Maintained: https://github.com/moby/moby/blob/master/hack/dind
    export container=docker
    if [ -d /sys/kernel/security ] && ! mountpoint -q /sys/kernel/security; then
        mount -t securityfs none /sys/kernel/security || {
            echo >&2 'Could not mount /sys/kernel/security.'
            echo >&2 'AppArmor detection and --privileged mode might break.'
        }
    fi
    # Mount /tmp (conditionally)
    if ! mountpoint -q /tmp; then
        mount -t tmpfs none /tmp
    fi
    # cgroup v2: enable nesting
    if [ -f /sys/fs/cgroup/cgroup.controllers ]; then
        # move the processes from the root group to the /init group,
        # otherwise writing subtree_control fails with EBUSY.
        # An error during moving non-existent process (i.e., "cat") is ignored.
        mkdir -p /sys/fs/cgroup/init
        xargs -rn1 < /sys/fs/cgroup/cgroup.procs > /sys/fs/cgroup/init/cgroup.procs || :
        # enable controllers
        sed -e 's/ / +/g' -e 's/^/+/' < /sys/fs/cgroup/cgroup.controllers \
            > /sys/fs/cgroup/cgroup.subtree_control
    fi
    ## Dind wrapper over.
    # Handle DNS
    set +e
    cat /etc/resolv.conf | grep -i 'internal.cloudapp.net'
    if [ $? -eq 0 ]
    then
        echo "Setting dockerd Azure DNS."
        CUSTOMDNS="--dns 168.63.129.16"
    else
        echo "Not setting dockerd DNS manually."
        CUSTOMDNS=""
    fi
    set -e
    # Start docker/moby engine
    ( dockerd $CUSTOMDNS > /tmp/dockerd.log 2>&1 ) &
INNEREOF
)"
# Start using sudo if not invoked as root
if [ "$(id -u)" -ne 0 ]; then
    sudo /bin/sh -c "${dockerd_start}"
else
    eval "${dockerd_start}"
fi
set +e
# Execute whatever commands were passed in (if any). This allows us
# to set this script to ENTRYPOINT while still executing the default CMD.
exec "$@"
EOF

chmod +x /usr/local/share/docker-init.sh
chown ${USERNAME}:root /usr/local/share/docker-init.sh

echo "== [Custom Ink] docker-in-docker-amzn script has completed! =="
