#!/bin/bash

set -o nounset
set -o errexit
set -o xtrace

# Create user account with uid 2000 to guarantee it won't change in the
# future (because the default user id 1000 might already be taken).
addgroup -g 2000 err && adduser -u 2000 -S -G err err
# Allow people to provide SSH keys to pull from private repositories.
mkdir -p /err/.ssh/
chown err:err /err/.ssh/

# Setup Errbot configuration folders
mkdir -p /err/data
chown err:err /err/data

# Install Err itself
if [[ $ERR_PYTHON_VERSION == "3" ]]; then

	pip install $ERR_PACKAGE
else
	echo "Unsupported Python version requested through ERR_PYTHON_VERSION"
	exit 1
fi
