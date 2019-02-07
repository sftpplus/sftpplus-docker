# To be used with the SFTPPlus Dockerfile.

# Get relevant deps per distribution installed.
. /etc/os-release
case ${ID} in
    rhel|centos)
        # Get the OpenSSL library, as this is the only dependency.
        yum check-update
        yum update openssl
        yum info openssl
        ;;
    debian)
        # Get the OpenSSL library, as this is the only dependency missing.
        apt-get update
        apt-get install -y openssl
        ;;
    alpine)
        # Get the libffi library, as this is the only dependency missing.
        apk update
        apk add libffi
        ;;
esac

# yum check-update has exit code 100 when packages need to be updated.
set -xe

# Link the unpacked sub-dir as /opt/sftpplus.
cd /opt
ln -s sftpplus-${SFTPPLUS_OS}-x64-${SFTPPLUS_VERSION} sftpplus

# Initialize SFTPPlus configuration.
# This will generate the SSH keys and the self signed certificates.
cd sftpplus
./bin/admin-commands.sh initialize

# Add default group and user.
case ${ID} in
    alpine)
        addgroup sftpplus
        adduser -G sftpplus -g "SFTPPlus" -s /bin/false -h /dev/null -H -D sftpplus
        ;;
    *)
        groupadd sftpplus
        useradd -g sftpplus -c "SFTPPlus" -s /bin/false -d /dev/null -M sftpplus
        ;;
esac

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
