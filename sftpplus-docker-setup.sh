# To be used with the SFTPPlus Dockerfile.

# Get relevant deps per distribution installed.
. /etc/os-release
case ${ID} in
    rhel|centos)
        # Get the OpenSSL library, as this is the only dependency.
        yum check-update
        yum update openssl
        yum info openssl
        yum clean all -y
        ;;
    ubuntu|debian)
        # Get the OpenSSL and libffi libraries, the only dependencies.
        apt-get update
        apt-get install -y openssl libffi7
        apt-get clean
        ;;
    alpine)
        # Update the already-included OpenSSL libs.
        apk update
        apk upgrade
        # Get the libffi library, as this is the only dependency missing.
        apk add libffi
        # Force cleaning the cache.
        rm -f /var/cache/apk/*
        ;;
esac

# yum check-update has exit code 100 when packages need to be updated.
set -xe

# Link the unpacked sub-dir as /opt/sftpplus.
cd /opt
mv sftpplus-${SFTPPLUS_PLATFORM}-* sftpplus

# A basic SFTPPlus configuration is picked up from configuration/, which
# requires SSL certificates and SSH keys generated through the next step.
mv /opt/configuration/* /opt/sftpplus/configuration/
rm -rf /opt/configuration

# Generate self-signed SSL certificate and private SSH keys, as set in the
# included SFTPPlus configuration.
cd sftpplus
./bin/admin-commands.sh generate-self-signed \
    --common-name=sftpplus-docker.example.com \
    --key-size=2048 \
    --sign-algorithm=sha256 \
    > configuration/self_signed_certificate.pem
./bin/admin-commands.sh generate-ssh-key \
    --key-file=configuration/ssh_host_rsa_key \
    --key-type=rsa \
    --key-size=2048
./bin/admin-commands.sh generate-ssh-key \
    --key-file=configuration/ssh_host_dsa_key \
    --key-type=dsa \
    --key-size=1024

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

# Create the basic storage directory for the default-enabled test_user account.
mkdir -p /srv/storage/test_user

# Adjust ownership of the configuration files and logs.
chown -R sftpplus \
    /opt/sftpplus/configuration \
    /opt/sftpplus/log \
    /srv/storage

# Add extra permissions for OpenShift Container Platform-specific guidelines.
chgrp -R 0 /opt/sftpplus/configuration \
    /opt/sftpplus/log \
    /srv/storage

chmod -R g=u /opt/sftpplus/configuration \
    /opt/sftpplus/log \
    /srv/storage

# Just to troubleshoot and check the permisisons are set ok at the
# end of the run.
ls -al /opt/sftpplus/
