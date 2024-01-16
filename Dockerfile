# Use quay.io/keycloak/keycloak:latest as the base image
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

# Copy the keycloak files to the image
# COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Set the environment variables for keycloak
# change these values to point to a running postgres instance
ENV KC_PROXY='edge'
ENV KC_DB='postgres'
ENV PROXY_ADDRESS_FORWARDING='true'
ENV KC_DB_URL='jdbc:postgresql://db.buwvyjjfiyfcgcdvbfke.supabase.co:5432/postgres'
ENV KC_DB_USERNAME='postgres'
ENV KC_HOSTNAME_PORT: 8080
ENV KC_DB_PASSWORD='Skyliner005!"£'
#ENV KC_HOSTNAME='ids-service.onrender.com'
ENV KC_HOSTNAME_URL = 'http://localhost:8080'
#ENV KC_HOSTNAME='ids-server.onrender.com'
ENV KEYCLOAK_ADMIN='admin'
ENV KEYCLOAK_ADMIN_PASSWORD='d55'

# Expose port 8080 for keycloak
EXPOSE 8080


# Use nginx image as the second stage
#FROM nginx:latest AS nginx

# Copy the nginx configuration file from the previous stage
# COPY --from=builder --chown=nginx:nginx opt/bitnami/nginx/conf/nginx.conf /etc/nginx/conf.d/default.conf
# Copy the nginx configuration file
#COPY nginx.conf /etc/nginx/nginx.conf




FROM ubuntu:latest

# Update the system and install Java 11
RUN apt update && apt install -y openjdk-17-jdk


RUN apt-get update && apt-get install -y nginx


# Set the JAVA_HOME environment variable
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64
COPY nginx.conf /etc/nginx/nginx.conf

# Copy your application jar file to the image
#COPY target/my-app.jar /opt/my-app.jar

# Define the default command for the container
CMD ["java", "-jar", "/opt/my-app.jar"]

COPY --from=builder opt/keycloak/ /opt/keycloak/
#COPY --from=nginx opt/nginx/ /opt/nginx/
#COPY --from=nginx etc/nginx/ /etc/nginx/
COPY --from=nginx /usr/share/nginx/html /usr/share/nginx/html




# Copy the start script and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh


# Expose port 80 for nginx
EXPOSE 80




# Use the start script as the entrypoint or the command
ENTRYPOINT ["/start.sh"]


#CMD nginx -g 'daemon off;' && /opt/bitnami/scripts/keycloak/run.sh --proxy=edge --hostname-strict=false
# CMD ["/opt/bitnami/scripts/keycloak/run.s --proxy=edge --auto-build --hostname-strict=false --http-port=8080  & nginx -g 'daemon off;'"]
# CMD ["/bin/bash", "-c", "/opt/bitnami/scripts/keycloak/run.sh --proxy=edge --auto-build --hostname-strict=false --http-port=8080 && nginx -g 'daemon off;'"]
#ENTRYPOINT [ "/opt/bitnami/scripts/keycloak/entrypoint.sh" ]
#CMD nginx -g 'daemon off;' && /opt/bitnami/scripts/keycloak/run.sh --proxy=edge --hostname-strict=false
#ENTRYPOINT ["/bin/sh", "-c", "/opt/bitnami/scripts/keycloak/run.sh start-dev --proxy=edge --auto-build --hostname-strict=false --hostname-strict-https=false --http-port=8080  & nginx -g 'daemon off;'"]
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


