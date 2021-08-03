if [ -z "$GOOGLE_APPLICATION_CREDENTIALS" ] ; then
    echo "Google Cloud storage disabled"
else
    echo "Mounting Google Cloud storage bucket '$GCS_BUCKET' in /srv/storage"
    gcsfuse -o nonempty $GCS_BUCKET /srv/storage/
fi

if [ -z "$S3_CREDENTIALS" ] ; then
    echo "S3 Cloud storage disabled"
else
    s3fs $S3_BUCKET /srv/storage -o nonempty -o passwd_file="${S3_CREDENTIALS}"
fi

if [ -z "$SFTPPLUS_CONFIGURATION" ] ; then
    # Use default configuration directory.
    SFTPPLUS_CONFIGURATION=/opt/sftpplus/configuration
fi

if [ -d "$SFTPPLUS_CONFIGURATION" ]; then
    echo "Configuration directory already initialized."
else
  echo "Initializing the configuration directory"
  cp -r /opt/sftpplus/configuration $SFTPPLUS_CONFIGURATION
fi

echo "Starting using configuration from: $SFTPPLUS_CONFIGURATION"
cd /opt/sftpplus
./bin/admin-commands.sh start-in-foreground --config="$SFTPPLUS_CONFIGURATION/server.ini"
