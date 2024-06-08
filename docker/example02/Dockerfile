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

# Use Ubuntu as the base image











FROM ubuntu:latest

# Set the environment to be non-interactive

ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages

RUN apt-get update 

RUN apt-get install -y git

RUN apt-get install -y tree

RUN apt-get install -y apache2

RUN apt-get install -y wget

RUN apt-get install -y curl

RUN apt-get install -y zip

RUN apt-get install -y unzip

RUN apt-get install -y python3

RUN apt-get install -y python3-pip

RUN apt-get install -y openjdk-17-jdk

RUN apt-get clean

RUN rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME environment variable

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

ENV PATH=$JAVA_HOME/bin:$PATH

# Expose port 80 for Apache

EXPOSE 80

# Start Apache server in the foreground

CMD ["apachectl", "-D","FOREGROUND"]