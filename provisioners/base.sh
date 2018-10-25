#!/bin/sh

set -o nounset
set -o errexit
set -o xtrace

APTINSTALL="apk add --no-cache"

echo LC_ALL="en_US.utf8" >> /etc/environment
#echo DEBIAN_FRONTEND="noninteractive" >> /etc/environment
#locale-gen en_US.UTF-8
#. /etc/environment
#PYTHON_PACKAGES="python3 python3-dev"

# Do a dist-upgrade because docker has not always updated their
# images in a timely manner after security updates were released.
#apk upgrade --no-cache

# In newer versions of Alpine Pip is not included in Python3 package
if [[ $ERR_PYTHON_VERSION == "3" ]]; then
	python3 -m ensurepip && \
	pip3 install --upgrade pip setuptools && \
rm -rf /root/.cache
fi

# TLS certs and sudo are needed, curl and vim are tremendously useful when entering
# a container for debugging (while barely increasing image size)
# Git and openssh-client are needed to install nearly all plugins
$APTINSTALL ca-certificates sudo curl git openssh-client

# Automatically add unknown host keys, users have no way to answer yes
# when using 'ask'.
echo '    StrictHostKeyChecking no' >> /etc/ssh/ssh_config
