# FROM ubuntu

# RUN useradd -m paul
# RUN groupadd manager
# RUN usermod -s /sbin/nologin -aG manager -c "paul smith" paul




FROM ubuntu

ARG FIRST_NAME=paul
ARG LAST_NAME=smith
ARG GROUP_NAME=manager
ARG HOME_DIR=/sbin/nologin

ENV APP_HOME /usr/src/app


# Set a label for the image
LABEL SCHOOL="DEL"

# Prevent interactive prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

VOLUME /data

# Update the package repository and install apache2
RUN apt-get update && \
    apt-get install -y wget zip unzip apache2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


WORKDIR /var/www/html/
RUN rm -rf *

RUN mkdir ADD
RUN mkdir COPY

ADD https://linux-devops-course.s3.amazonaws.com/creative.zip .
RUN unzip creative.zip
RUN rm -rf creative.zip

COPY ./index.html /var/www/html/COPY/index.html

ADD ./index.html /var/www/html/ADD/index.html

RUN useradd -m $FIRST_NAME
RUN groupadd $GROUP_NAME
RUN usermod -s $HOME_DIR -aG $GROUP_NAME -c "$FIRST_NAME $LAST_NAME" $FIRST_NAME

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
