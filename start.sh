#!/bin/bash

# Download and run the install-java.sh script
# wget https://raw.githubusercontent.com/chrishantha/install-java/master/install-java.sh
# chmod +x install-java.sh
# sudo ./install-java.sh -f jdk-11.0.12_linux-x64_bin.tar.gz -p /opt/java
# # Set the JAVA variable to the path of the Java executable
# export JAVA=/opt/java/jdk-11.0.12/bin/java

# Start nginx in the background
nginx -g 'daemon off;' &
# Start keycloak in the background
/opt/keycloak/bin/kc.sh &
# Wait for both processes to finish
wait
