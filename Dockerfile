###############################################################################
# Image configuration
#
# Update the value from this section to match your needs.
#
# This Dockerfile was tested with the following upstream Docker images:
# * centos:8
# * ubuntu:20.04
# * alpine:3.12
FROM centos:8

# Official Dockerfile for SFTPPlus.
MAINTAINER support@sftpplus.com

# SFTPPlus moniker for the current OS (rhel8, ubuntu2004, alpine312).
ENV SFTPPLUS_OS rhel8
# For the non-trial package, this would be the version, eg. "4.0.0".
ENV SFTPPLUS_VERSION trial

# Inform Docker about the ports used by SFTPPlus.
# * Local Manager
# * HTTPS file servers
# * SFTP file server
# * Explicit FTPS command port
# * Explicit FTPS passive data ports.
EXPOSE 10020 10443 10022 10021 10900-10910

###############################################################################
# Build steps
#

# Add the files needed to customize the image.
ADD sftpplus-${SFTPPLUS_OS}-x64-${SFTPPLUS_VERSION}.tar.gz sftpplus-docker-setup.sh /opt/
ADD configuration/ /opt/configuration/

# Unpack the tarball and initialize setup.
RUN /opt/sftpplus-docker-setup.sh

# SFTPPlus install dir.
WORKDIR /opt/sftpplus

# Start the server.
# In debug mode all logs are sent to stdout, enabling Docker logs.
USER sftpplus
CMD [ "bin/admin-commands.sh", "debug" ]
