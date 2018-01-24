# Uses an official image for Alpine as a parent image.
FROM alpine:3.6

# Official Dockerfile for SFTPPlus.
MAINTAINER support@sftpplus.com

# Define version as an environment variable.
ENV SFTPPLUS_VERSION 3.29.0

# Put the files needed to customize the image.
ADD configuration/ sftpplus-alpine36-x64-${SFTPPLUS_VERSION}.tar.gz sftpplus-docker-setup.sh /opt

# Inform docker about what ports are used by the application.
# * Local Manager
# * HTTP / HTTPS file servers
# * SFTP file server
# * SCP file server
# * Explicit FTPS command port
# * Implicit FTPS command port
# * Implicit and Explicit FTPS passive data ports.
EXPOSE 10020 10080 10443 10022 10023 10021 10990 10900-10910

# Unpack the tarball and do the initial setup.
RUN /tmp/sftpplus-docker-setup.sh

# SFTPPlus install dir.
WORKDIR /opt/sftpplus

# Start the server (in debug mode for now, to log to stdout as well, enabling Docker logs).
CMD [ "bin/admin-commands.sh", "debug" ]
