FROM ubuntu:latest

# Set the environment to be non-interactive

ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages

RUN apt-get update && \
    apt-get install -y git tree apache2 wget curl zip unzip python3 python3-pip && \
    apt-get install -y openjdk-17-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME environment variable

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

ENV PATH=$JAVA_HOME/bin:$PATH

# Expose port 80 for Apache

EXPOSE 80

# Start Apache server in the foreground

CMD ["apachectl", "-D", "FOREGROUND"]


## ================================================================

# Use an official Alpine Linux as a parent image
FROM alpine:latest

# Set a label for the image
LABEL maintainer="you@example.com"

# Update the package repository and install required packages
RUN apk update && \
    apk add --no-cache \
    git \
    tree \
    apache2 \
    wget \
    curl \
    zip \
    unzip \
    python3 \
    py3-pip \
    openjdk17-jdk

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Expose port 80 for Apache
EXPOSE 80

# Start Apache server in the foreground
CMD ["httpd", "-D", "FOREGROUND"]
