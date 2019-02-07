###############################################################################
# Image configuration
#
# Update the value from this section to match your needs.
#
# This repo contains samples for the following upstream Docker images:
# * centos:7
# * debian:8
# * alpine:3.7
FROM centos:7

# Official Dockerfile for SFTPPlus.
MAINTAINER support@sftpplus.com

# Code of the OS on which SFTPPlus runs (rhel7, debian8, alpine37).
ENV SFTPPLUS_OS rhel7
# For the non-trial version it will be the version, eg. "3.44.0".
ENV SFTPPLUS_VERSION trial

# Inform docker about what ports are used by the application.
# * Local Manager
# * HTTP / HTTPS file servers
# * SFTP file server
# * SCP file server
# * Explicit FTPS command port
# * Implicit FTPS command port
# * Implicit and Explicit FTPS passive data ports.
EXPOSE 10020 10080 10443 10022 10023 10021 10990 10900-10910

###############################################################################
# Build steps
#

# Add the files needed to customize the image.
ADD sftpplus-${SFTPPLUS_OS}-x64-${SFTPPLUS_VERSION}.tar.gz sftpplus-docker-setup.sh /opt/
ADD configuration/ /opt/configuration/

# Unpack the tarball and do the initial setup.
RUN /opt/sftpplus-docker-setup.sh

# SFTPPlus install dir.
WORKDIR /opt/sftpplus

# Start the server.
# In debug mode all logs are sent to stdout, enabling Docker logs.
USER sftpplus
CMD [ "bin/admin-commands.sh", "debug" ]
