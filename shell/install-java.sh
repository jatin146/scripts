#!/bin/bash

sudo apt install openjdk-11-jre-headless -y
sudo apt install openjdk-11-jdk-headless -y


# Also print the versions of the Java and Java compiler installed
echo "JAVA VERSION"
echo "============"
java -version

echo "JAVAC VERSION"
echo "============="
javac -version
