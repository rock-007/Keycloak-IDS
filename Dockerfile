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
# RUN sudo apk add --update openjdk8
# RUN sudo apk add --update ant
# # Install OpenJDK-8
# RUN apt update && \
#     apt install -y openjdk-8-jdk && \
#     apt install -y ant && \
#     apt clean;
    
# # Fix certificate issues
# RUN apt update && \
#     apt install -y ca-certificates-java && \
#     apt clean && \
#     update-ca-certificates -f;


# Setup JAVA_HOME -- useful for docker commandline
# ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
# RUN export JAVA_HOME
# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build



#Create SSL certificate
#RUN openssl req -newkey rsa:2048 -nodes \
#  -keyout server.key.pem -x509 -days 3650 -out server.crt.pem
#RUN chmod 755 /server.key.pem
COPY  server.crt.pem /etc/x509/https/tls.crt
COPY  server.key.pem /etc/x509/https/tls.key
EXPOSE 8080

 
# change these values to point to a running postgres instance
ENV KC_PROXY='passthrough'
ENV KC_DB='postgres'
ENV PROXY_ADDRESS_FORWARDING='true'
ENV KC_DB_URL='jdbc:postgresql://db.buwvyjjfiyfcgcdvbfke.supabase.co:5432/postgres'
ENV KC_DB_USERNAME='postgres'
ENV KC_HOSTNAME_PORT: 8443
ENV KC_DB_PASSWORD='Skyliner005!"£'
ENV KC_HOSTNAME='localhost'
#ENV KEYCLOAK_CONTENT_SECURITY_POLICY= "frame-src 'self'; frame-ancestors 'self' http://localhost:3000; object-src 'none'
#ENV KC_HOSTNAME='ids-server.onrender.com'
ENV KEYCLOAK_ADMIN='admin'
ENV KEYCLOAK_ADMIN_PASSWORD='d55'
# ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start","--http-port=8080", "--db-driver=postgres"] for production
#ENTRYPOINT ["/opt/keycloak/bin/kc.sh","start-dev","--hostname-strict-https=true"]
# CMD ["--hostname-port", "8080"]
CMD ["/opt/keycloak/bin/kc.sh","start-dev","--hostname-strict-https=true","--http-port=8080"]


# Use Nginx as the base image
FROM nginx


# Expose the port that Nginx listens on
#VOLUME /usr/share/nginx/html
#VOLUME /etc/nginx/nginx.conf

# Copy the Nginx configuration file
#COPY content /usr/share/nginx/html
COPY --chown=nginx:nginx nginx.conf /etc/nginx/nginx.conf
# Copy the Keycloak service from the previous stage
COPY --from=builder /opt/keycloak/ /opt/keycloak/




EXPOSE 8080
# Run both services
ENTRYPOINT ["/bin/sh", "-c", "/opt/keycloak/bin/kc.sh start-dev --proxy=edge --auto-build  & nginx -g 'daemon off;'"]


