# Helper to test and develop the container.
# Starts the container using the local docker.
#
docker image rm sftpplus:debug
docker build -t sftpplus:debug .
docker rm -f sftpplus-debug
docker run -ti --name sftpplus-debug \
    --device /dev/fuse \
    --privileged \
    --cap-add SYS_ADMIN \
    -v `pwd`/credentials:/srv/credentials \
    -p 10020:10020/tcp -p 10022:10022/tcp \
    -e SFTPPLUS_CONFIGURATION=/srv/storage/configuration \
    sftpplus:debug bash


    # To run with AWS S3
    # -e S3_BUCKET=sftpplus-trial-srv-storage \
    # -e S3_CREDENTIALS=/srv/credentials/s3fs-passwd \

docker rm -f sftpplus-debug
