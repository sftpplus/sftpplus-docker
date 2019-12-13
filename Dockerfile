###############################################################################
# Image configuration
#
# Update the value from this section to match your needs.
#
# This Dockerfile was tested with the following upstream Docker images:
# * centos:7
# * ubuntu:18.04
# * debian:9
# * alpine:3.10
FROM centos:7

# Official Dockerfile for SFTPPlus.
MAINTAINER support@sftpplus.com

# SFTPPlus moniker for the current OS (rhel7, ubuntu1804, debian9, alpine310).
ENV SFTPPLUS_OS rhel7
# For the non-trial package, this would be the version, eg. "3.51.0".
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
