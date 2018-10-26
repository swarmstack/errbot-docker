#!/bin/sh

set -o nounset
set -o errexit
set -o xtrace

APTINSTALL="apk add --no-cache"

echo LC_ALL="en_US.utf8" >> /etc/environment
echo DEBIAN_FRONTEND="noninteractive" >> /etc/environment
. /etc/environment

$APTINSTALL python3 python3-dev

# TLS certs and sudo are needed, curl and vim are tremendously useful when entering
# a container for debugging (while barely increasing image size)
# Git and openssh-client are needed to install nearly all plugins
$APTINSTALL ca-certificates sudo curl git openssh-client

# Automatically add unknown host keys, users have no way to answer yes
# when using 'ask'.
echo '    StrictHostKeyChecking no' >> /etc/ssh/ssh_config
