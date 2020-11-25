#!/bin/bash

# Using instructions at: https://github.com/nodesource/distributions/blob/master/README.md#debinstall
# We will install the LTS version (14.15.1)
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Check if the node is installed
node -v

# Check of the npm is installed successfully
npm -v
