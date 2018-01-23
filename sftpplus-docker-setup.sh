# To be used with the SFTPPlus Dockerfile.
set -xe

# Link the unpacked sub-dir as /opt/sftpplus.
cd /opt
ln -s sftpplus-alpine36-x64-${SFTPPLUS_VERSION} sftpplus

# Initialize SFTPPlus configuration.
cd sftpplus
./bin/admin-commands.sh initialize

# Add default group and user.
addgroup sftpplus
adduser -G sftpplus -g "SFTPPlus" -s /bin/false -h /dev/null -H -D sftpplus

# Adjust ownership of the configuration files and logs.
chown -R sftpplus:sftpplus /opt/sftpplus/configuration /opt/sftpplus/log
