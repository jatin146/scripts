#!/bin/bash


# First install required dependencies
sudo apt install -y make
sudo apt install -y gcc
sudo apt install -y tcl

# Create a directory where we will copy the sources to
mkdir ~/redis

# Download stable redis into that directory
wget -O ~/redis/redis-stable.tar.gz http://download.redis.io/redis-stable.tar.gz

# Go to redis directory and deflate the gzipped tar ball
cd ~/redis
tar xvzf redis-stable.tar.gz

# Now go to the redis installatio and build from source
cd redis-stable

# Compile the code and generate binaries
make

# Copy couple of binaries to /usr/local/bin
# We do this before testing to make sure that we can still have redis if tests fail
sudo cp src/redis-server /usr/local/bin/
sudo cp src/redis-cli /usr/local/bin/

# Create the /etc/redis folder and copy the config file there
sudo mkdir /etc/redis
sudo cp ~/redis/redis-stable/redis.conf /etc/redis/

# test everything
# make test

