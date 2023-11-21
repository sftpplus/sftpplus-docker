# Helper to test and develop the container.
# Starts the container using the local docker.
#

if [ -n "$(docker images -q sftpplus:debug)" ]; then
    docker image rm sftpplus:debug
fi
docker build -t sftpplus:debug .
if [ "$(docker ps -a -f name=sftpplus-debug | wc -l)" -gt 1 ]; then
    docker rm -f sftpplus-debug
fi
docker run -ti --name sftpplus-debug \
    -p 10020:10020/tcp -p 10022:10022/tcp \
    -e SFTPPLUS_CONFIGURATION=/srv/storage/configuration \
    sftpplus:debug  # /bin/bash  # if you don't what to auto-start.

docker rm -f sftpplus-debug
docker image rm sftpplus:debug
