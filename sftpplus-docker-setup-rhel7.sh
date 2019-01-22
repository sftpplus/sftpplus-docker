# To be used with the SFTPPlus Dockerfile.

# Get the OpenSSL library as this is the only dependency.
yum check-update
yum update openssl
yum info openssl

# yum check-updates has exit code 100 when packages need to be updated.
set -xe

# Link the unpacked sub-dir as /opt/sftpplus.
cd /opt
ln -s sftpplus-${SFTPPLUS_OS}-x64-${SFTPPLUS_VERSION} sftpplus

# Initialize SFTPPlus configuration.
# This will generate the SSH keys and the self signed certificates.
cd sftpplus
./bin/admin-commands.sh initialize

# Add default group and user.
groupadd sftpplus
useradd -g sftpplus -c "SFTPPlus" -s /bin/false -d /dev/null -M sftpplus

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
