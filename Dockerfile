# Uses an official image for Alpine as a parent image.
FROM alpine:3.6

# Official Dockerfile for SFTPPlus.
MAINTAINER support@sftpplus.com

# Define version as an environment variable.
ENV SFTPPLUS_VERSION 3.29.0

# Put the Alpine tarball and our setup script into the container.
ADD sftpplus-alpine36-x64-${SFTPPLUS_VERSION}.tar.gz sftpplus-docker-setup.sh /opt/

# Make ports available to the outside world.
EXPOSE 10080 10020 10021 10022 10443

# Unpack the tarball and do the initial setup.
RUN /opt/sftpplus-docker-setup.sh

# SFTPPlus install dir.
WORKDIR /opt/sftpplus

# Start the server (in debug mode for now, to log to stdout as well, enabling Docker logs).
CMD [ "bin/admin-commands.sh", "debug" ]
