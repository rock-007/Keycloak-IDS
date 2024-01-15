#!/bin/bash
# Start nginx in the background
nginx -g 'daemon off;' &
# Start keycloak in the background
/opt/bitnami/keycloak/run.sh &
# Wait for both processes to finish
wait
