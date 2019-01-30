# To be used with the SFTPPlus Dockerfile.
set -xe

# Get the libffi library as this is the only dependency missing.
apk update
apk add libffi

# Link the unpacked sub-dir as /opt/sftpplus.
cd /opt
ln -s sftpplus-${SFTPPLUS_OS}-x64-${SFTPPLUS_VERSION} sftpplus

# Initialize SFTPPlus configuration.
# This will generate the SSH keys and the self signed certificates.
cd sftpplus
./bin/admin-commands.sh initialize

# Add default group and user.
addgroup sftpplus
adduser -G sftpplus -g "SFTPPlus" -s /bin/false -h /dev/null -H -D sftpplus

# Merge the configuration file and clean the source configuration.
mv /opt/configuration/* /opt/sftpplus/configuration/
rm -rf /opt/configuration

# Create the basic storage folder for the test user.
mkdir -p /srv/storage/test_user

# Adjust ownership of the configuration files and logs.
chown -R sftpplus:sftpplus \
    /opt/sftpplus/configuration \
    /opt/sftpplus/log \
    /srv/storage
