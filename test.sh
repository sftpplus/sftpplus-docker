# Helper to test and develop the container.
# Starts the container using the local docker.
#
docker image rm sftpplus:debug
docker build -t sftpplus:debug .
docker rm -f sftpplus-debug
docker run -ti --name sftpplus-debug \
    -p 10020:10020/tcp -p 10022:10022/tcp \
    -e SFTPPLUS_CONFIGURATION=/srv/storage/configuration \
    sftpplus:debug  # /bin/bash  # if you don't what to auto-start.

docker rm -f sftpplus-debug
