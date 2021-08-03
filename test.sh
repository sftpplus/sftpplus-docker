# Helper to test and develop the container.
# Starts the container using the local docker.
#
#docker image rm sftpplus:debug
#docker build -t sftpplus:debug .
docker rm -f sftpplus-debug
docker run -ti --name sftpplus-debug \
    --device /dev/fuse \
    --privileged \
    --cap-add SYS_ADMIN \
    -v `pwd`/credentials:/srv/credentials \
    -p 10020:10020/tcp -p 10022:10022/tcp \
    # To run with custom configuration directory
    -e SFTPPLUS_CONFIGURATION=/srv/storage/configuration \
    sftpplus:debug
    # To run with Google Cloud Storage
    # -e GOOGLE_APPLICATION_CREDENTIALS=/srv/credentials/gcs-key.json \
    # -e GCS_BUCKET=sftpplus-trial-srv-storage \
    # To run with AWS S3
    # -e S3_BUCKET=sftpplus-trial-srv-storage \
    # -e S3_CREDENTIALS=/srv/credentials/s3fs-passwd \

docker rm -f sftpplus-debug
