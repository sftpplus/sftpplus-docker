if [ -z "$SFTPPLUS_CONFIGURATION" ] ; then
    # Use default configuration directory.
    SFTPPLUS_CONFIGURATION=/opt/sftpplus/configuration
fi

if [ -f "${SFTPPLUS_CONFIGURATION}/server.ini" ]; then
    echo "Configuration directory already initialized."
else
  echo "Initializing the configuration"
  mkdir -p ${SFTPPLUS_CONFIGURATION}
  cp /opt/sftpplus/configuration/server.ini.seed ${SFTPPLUS_CONFIGURATION}/server.ini
  ./bin/admin-commands.sh generate-self-signed \
    --common-name=sftpplus-docker.example.com \
    --key-size=2048 \
    --sign-algorithm=sha256 \
    > ${SFTPPLUS_CONFIGURATION}/ssl_certificate.pem
  ./bin/admin-commands.sh generate-ssh-key \
    --key-file=${SFTPPLUS_CONFIGURATION}/ssh_host_rsa_key \
    --key-type=rsa \
    --key-size=2048
  # Cleanup public key as we don't need it.
  rm ${SFTPPLUS_CONFIGURATION}/ssh_host_rsa_key.pub
fi

echo "Starting using configuration from: $SFTPPLUS_CONFIGURATION"
cd ${SFTPPLUS_CONFIGURATION}/../
/opt/sftpplus/bin/admin-commands.sh start-in-foreground \
  --config="$SFTPPLUS_CONFIGURATION/server.ini"
