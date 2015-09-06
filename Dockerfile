#
# MongoDB Dockerfile
#
# https://github.com/dockerfile/mariadb
#

# Pull base image.
FROM resin/rpi-raspbian:wheezy

# Creating mongodb user
RUN groupadd -r mongodb && useradd -r -g mongodb mongodb

# Installing mongo to /opt/mongo
RUN sudo apt-get update
RUN sudo apt-get install -y curl
RUN sudo apt-get install -y p7zip-full
RUN curl -O http://facat.github.io/mongodb-2.6.4-arm.7z
RUN 7z x mongodb-2.6.4-arm.7z
RUN mv mongodb /opt/mongodb
RUN rm -f mongodb-2.6.4-arm.7z
RUN sudo chown -R mongodb /opt/mongodb

# Create the mongo data dirs
RUN sudo mkdir -p /data/db && \
    sudo chown mongodb /data/db

# Creating runtime directories under /var
RUN install -o mongodb -g mongodb -d /var/log/mongodb/ && \
    install -o mongodb -g mongodb -d /var/lib/mongodb/

# Installing config scripts
ADD mongodb.conf .
RUN install mongodb.conf /etc

VOLUME /data/db

EXPOSE 27017
CMD ["/opt/mongodb/bin/mongod"]
