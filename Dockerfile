FROM quay.io/keycloak/keycloak:latest as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=false
ENV KC_METRICS_ENABLED=false

# Configure a database vendor
# ENV KC_DB=postgres
# Enable http
# ARG KC_HTTP_ENABLED=true

#  Default proxy
# ARG KC_PROXY=edge

#  Log
# ARG KC_LOG_CONSOLE_OUTPUT=json

# # Default user
# ARG KEYCLOAK_ADMIN=admin
# ARG KEYCLOAK_ADMIN_PASSWORD=change_me
WORKDIR /opt/keycloak
# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/
EXPOSE 8443
# change these values to point to a running postgres instance
ENV KC_DB='postgres'
ENV KC_DB_URL='jdbc:postgresql://db.buwvyjjfiyfcgcdvbfke.supabase.co:5432/postgres'
ENV KC_DB_USERNAME='postgres'
ENV KC_DB_PASSWORD='Skyliner005!"£'
#ENV KC_HOSTNAME='127.0.0.1'
#ENV KC_HOSTNAME='keycloak-ids'
ENV KEYCLOAK_ADMIN='admin'
ENV KEYCLOAK_ADMIN_PASSWORD='d55'
# ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start","--http-port=8080", "--db-driver=postgres"] for production
ENTRYPOINT ["/opt/keycloak/bin/kc.sh","start-dev"]
# CMD ["--hostname-port", "8080"]
