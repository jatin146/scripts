#!/bin/bash

sudo apt install openjdk-11-jre-headless
sudo apt install openjdk-11-jdk-headless


# Also print the versions of the Java and Java compiler installed
echo "JAVA VERSION"
echo "============"
java -version

echo "JAVAC VERSION"
echo "============="
javac -version
