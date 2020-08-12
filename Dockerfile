###############################################################################
# Docker image configuration
#
# Update set values to match a customized SFTPPlus setup.
#
# This Dockerfile is tested with the following upstream Docker images (but
# works with others as well, as long as you use the right SFTPPlus package):
# * centos:8
# * ubuntu:20.04
# * alpine:3.12
FROM centos:8

# Official Dockerfile for SFTPPlus.
MAINTAINER support@sftpplus.com

# SFTPPlus moniker for the current OS (e.g. "rhel8", "ubuntu2004", "alpine312").
ENV SFTPPLUS_OS rhel8
# For the non-trial package, this would be the version, eg. "4.0.0".
ENV SFTPPLUS_VERSION trial

# Expose through Docker the ports used by SFTPPlus.
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

# Start the server in foreground, to be managed by Docker.
# To log to Docker only, the standard-stream event handler is enabled through
# the default configuration file picked up from configuration/, which also
# disables the default logging to file and SQLite database.
USER sftpplus
CMD [ "bin/admin-commands.sh", "start-in-foreground" ]
