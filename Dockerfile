# The trial SFTPPlus version is based on Debian 7.
# For the Docker image we are using a minimal Debian distribution.
FROM debian:7-slim

# Official Dockerfile for SFTPPlus.
MAINTAINER support@sftpplus.com

# Define version as an environment variable.
# For the non-trial version, it will be linux-x64-3.29.0:
ENV SFTPPLUS_VARIANT linux-x64-trial

# Put the files needed to customize the image.
ADD sftpplus-${SFTPPLUS_VARIANT}.tar.gz sftpplus-docker-setup.sh /opt/
ADD configuration/ /opt/configuration/

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
RUN /opt/sftpplus-docker-setup.sh

# SFTPPlus install dir.
WORKDIR /opt/sftpplus

# Start the server (in debug mode for now, to log to stdout as well, enabling Docker logs).
CMD [ "bin/admin-commands.sh", "debug" ]
