#!/bin/bash
# Start nginx in the background
nginx -g 'daemon off;' &
# Start keycloak in the background
/opt/keycloak/bin/kc.sh &
# Wait for both processes to finish
wait
