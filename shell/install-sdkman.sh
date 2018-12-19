# sdkman needs unzip installed on the machine
sudo apt-get install unzip
sudo apt-get install zip

#!/bin/bash
curl -s "https://get.sdkman.io" | bash

# Source the sdkman init
source ~/.sdkman/bin/sdkman-init.sh

# Print out the installed version of sdkman
sdk version
