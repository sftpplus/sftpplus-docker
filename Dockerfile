###############################################################################
# Docker image configuration
#
# Update default values to match a customized SFTPPlus setup.
#
# This Dockerfile is tested with the following upstream Docker images (but
# works with others as well, as long as you use the right SFTPPlus package):
# * centos:8
# * ubuntu:20.04
# * alpine:3.12

ARG base_image="ubuntu:20.04"
ARG target_platform=ubuntu2004-x64

###############################################################################
# Image details
#

FROM $base_image
# Need to repeat them to be available after FROM
# See https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG base_image
ARG target_platform

# SFTPPlus moniker for the current OS (e.g. "rhel8-x64", "ubuntu2004-x64", "alpine312-x64").
ENV SFTPPLUS_PLATFORM $target_platform

# For the non-trial package, this would be the version, eg. "4.0.0".
ENV SFTPPLUS_VERSION trial

# Official Dockerfile for SFTPPlus.
MAINTAINER support@sftpplus.com

# Expose through Docker the ports used by SFTPPlus.
# * Local Manager
# * HTTPS file servers
# * SFTP file server
# * Explicit FTPS command port
# * Explicit FTPS passive data ports.
# When targeting OpenShift make sure all ports are above 1024.
EXPOSE 10020 10443 10022 10021 10900-10910

###############################################################################
# Build steps
#

# Add the files needed to customize the image.
ADD sftpplus-${SFTPPLUS_PLATFORM}-${SFTPPLUS_VERSION}.tar.gz sftpplus-docker-setup.sh sftpplus-docker-entrypoint.sh /opt/
ADD configuration/ /opt/configuration/

# Unpack the tarball and initialize setup.
RUN /opt/sftpplus-docker-setup.sh
RUN ls -al /opt/sftpplus/


# SFTPPlus install dir.
WORKDIR /opt/sftpplus

# The Dockerfile USER instruction is ignored on OpenShift, where a different
# arbitrary user ID is used for each container
USER sftpplus

# Start the server in foreground, to be managed by Docker.
# To log to Docker only, the standard-stream event handler is enabled through
# the default configuration file picked up from configuration/, which also
# disables the default logging to file and SQLite database.
CMD [ "/bin/sh", "/opt/sftpplus-docker-entrypoint.sh" ]
