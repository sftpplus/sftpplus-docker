SFTPPlus Docker files
=====================

`Dockerfile` and related files for creating Docker containers running
Pro:Atria's SFTPPlus server.

Step-by-step guide:

  * We assume a working Docker setup, we used version 17.06.0-ce.

  * Put `Dockerfile`, `sftpplus-docker-setup.sh` and the correspoding Alpine
  packagein the same directory (adjust `SFTPPLUS_VERSION` in `Dockerfile`,
  if necessary.)

  * From inside that directory build the `sftpplus` container with::

    docker build -t sftpplus .

  * If successful, you may start the new Docker container with::

    docker run sftpplus
