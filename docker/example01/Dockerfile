# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set a label for the image
LABEL maintainer="you@example.com"

# Prevent interactive prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Update the package repository and install apache2
RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy a custom index.html to the Apache directory (optional)
COPY ./index.html /var/www/html/index.html

# Expose port 80 to the outside world
EXPOSE 80

# Set the default command to run Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]



FROM alpine:latest

# Set a label for the image
LABEL maintainer="you@example.com"

# Update the package repository and install apache2
RUN apk update && \
    apk add --no-cache apache2

# Copy a custom index.html to the Apache directory (optional)
COPY ./index.html /var/www/localhost/htdocs/index.html

# Expose port 80 to the outside world
EXPOSE 80

# Set the default command to run Apache in the foreground
CMD ["httpd", "-D", "FOREGROUND"]

