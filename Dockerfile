FROM quay.io/keycloak/keycloak:latest as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak
# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/



ENTRYPOINT ["/opt/keycloak/bin/kc.sh", \
            "-e", "KC_DB=postgres", \
            "-e", "KC_DB_URL='db.buwvyjjfiyfcgcdvbfke.supabase.co'", \
            "-e", "KC_DB_USERNAME='postgres'", \
            "-e", "KC_DB_PASSWORD='Skyliner005!"£'", \
            "-e", "KC_HOSTNAME='keycloak-ids.onrender.com'", \
            "-e", "KEYCLOAK_ADMIN='admin'", \
            "-e", "KEYCLOAK_ADMIN_PASSWORD='d55'"
]
