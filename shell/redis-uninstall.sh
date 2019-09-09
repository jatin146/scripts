#!/bin/bash

# Stop the server is it is running
redis-cli ping


# Delete the binaries from /usr/local/bin/
sudo rm /usr/local/bin/redis-server
sudo rm /usr/local/bin/redis-cli


# Delete the /etc/redis folder
sudo rm -rf /etc/redis

# Delete the redis folder
rm -rf ~/redis

# Delete the database file
rm -rf dump.rdb

