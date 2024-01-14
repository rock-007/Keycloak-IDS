# Use bitnami/keycloak as base image
FROM bitnami/keycloak:latest

# Set environment variables for database connection
ENV KEYCLOAK_DATABASE_HOST=jdbc:postgresql://db.buwvyjjfiyfcgcdvbfke.supabase.co:5432
ENV KEYCLOAK_DATABASE_PORT=5432
ENV KEYCLOAK_DATABASE_NAME=postgres
ENV KEYCLOAK_DATABASE_USER=postgres
ENV KEYCLOAK_DATABASE_PASSWORD=Skyliner005!"£

# Expose port 8080 for Keycloak
EXPOSE 8080


# FROM bitnami/keycloak:22-debian-11 as builder
# # RUN dnf update -y && \
# #     dnf install -y curl wget unzip && \
# #     dnf clean all && \
# #     dnf install -y java-1.8.0-openjdk-devel && \
# #     dnf install -y ant && \
# #     dnf clean all
# # ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk/
# # RUN export JAVA_HOME




# # Enable health and metrics support
# ENV KC_HEALTH_ENABLED=false
# ENV KC_METRICS_ENABLED=false

# WORKDIR /opt/keycloak

# # for demonstration purposes only, please make sure to use proper certificates in production instead
# #RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
# RUN /opt/keycloak/bin/kc.sh build --db=postgres
# #RUN ./bin/kc.sh build --db=postgres


# #Create SSL certificate
# #RUN openssl req -newkey rsa:2048 -nodes \
# #  -keyout server.key.pem -x509 -days 3650 -out server.crt.pem
# #RUN chmod 755 /server.key.pem
# COPY  server.crt.pem /etc/x509/https/tls.crt
# COPY  server.key.pem /etc/x509/https/tls.key
# EXPOSE 8080

 
# # change these values to point to a running postgres instance
# ENV KC_PROXY='edge'
# ENV KC_DB='postgres'
# ENV PROXY_ADDRESS_FORWARDING='true'
# ENV KC_DB_URL='jdbc:postgresql://db.buwvyjjfiyfcgcdvbfke.supabase.co:5432/postgres'
# ENV KC_DB_USERNAME='postgres'
# ENV KC_HOSTNAME_PORT: 8080
# ENV KC_DB_PASSWORD='Skyliner005!"£'
# #ENV KC_HOSTNAME='ids-service.onrender.com'
# ENV KC_HOSTNAME_URL = 'http://localhost:8080'
# #ENV KEYCLOAK_CONTENT_SECURITY_POLICY= "frame-src 'self'; frame-ancestors 'self' http://localhost:3000; object-src 'none'
# #ENV KC_HOSTNAME='ids-server.onrender.com'
# ENV KEYCLOAK_ADMIN='admin'
# ENV KEYCLOAK_ADMIN_PASSWORD='d55'
# # ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start","--http-port=8080", "--db-driver=postgres"] for production
# #ENTRYPOINT ["/opt/keycloak/bin/kc.sh","start-dev","--hostname-strict-https=true"]
# # CMD ["--hostname-port", "8080"]
# CMD ["/opt/keycloak/bin/kc.sh","start-dev","--hostname-strict-https=false","--http-port=8080"]


# # Use Nginx as the base image
# FROM nginx


# # Expose the port that Nginx listens on
# #VOLUME /usr/share/nginx/html
# #VOLUME /etc/nginx/nginx.conf

# # Copy the Nginx configuration file
# #COPY content /usr/share/nginx/html
# COPY --chown=nginx:nginx nginx.conf /etc/nginx/nginx.conf
# # Copy the Keycloak service from the previous stage
# COPY --from=builder opt/keycloak/ /opt/keycloak/

# # change these values to point to a running postgres instance
# ENV KC_PROXY='edge'
# ENV KC_DB='postgres'
# ENV PROXY_ADDRESS_FORWARDING='true'
# ENV KC_DB_URL='jdbc:postgresql://db.buwvyjjfiyfcgcdvbfke.supabase.co:5432/postgres'
# ENV KC_DB_USERNAME='postgres'
# ENV KC_HOSTNAME_PORT: 8080
# ENV KC_DB_PASSWORD='Skyliner005!"£'
# ENV KC_HOSTNAME='ids-service.onrender.com'
# ENV KC_HOSTNAME_URL = 'http://localhost:8080'
# #ENV KEYCLOAK_CONTENT_SECURITY_POLICY= "frame-src 'self'; frame-ancestors 'self' http://localhost:3000; object-src 'none'
# #ENV KC_HOSTNAME='ids-server.onrender.com'
# ENV KEYCLOAK_ADMIN='admin'
# ENV KEYCLOAK_ADMIN_PASSWORD='d55'



# EXPOSE 8080
# # Run both services
# ENTRYPOINT ["/bin/sh", "-c", "/opt/keycloak/bin/kc.sh start-dev --proxy=edge --auto-build --hostname-strict=false --hostname-strict-https=false --http-port=8080  & nginx -g 'daemon off;'"]


