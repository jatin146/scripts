#!/bin/bash

# Check if sdkman exists
if [ ! -d "$HOME/.sdkman" ]; then
  echo "SDKMAN does not exist"
  echo "Please run install-sdkman.sh before continuing further"
  exit 1
fi

# SOurce the sdkman init file to prepare the environment
source $HOME/.sdkman/bin/sdkman-init.sh

# Install gradle, maven and ant
echo "Installing ANT"
sdk install ant

echo "Installing Maven"
sdk install maven

echo "Installing Gradle"
sdk install gradle

