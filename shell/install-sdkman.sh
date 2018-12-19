# sdkman needs unzip installed on the machine
sudo apt-get install unzip

#!/bin/bash
curl -s "https://get.sdkman.io" | bash

# Print out the installed version of sdkman
sdk version
