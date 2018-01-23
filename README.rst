SFTPPlus Docker
===============

`Dockerfile` and related files for creating Docker containers running
Pro:Atria's SFTPPlus server.

`sftpplus-docker-setup.sh` is the main script which is called to create the
SFTPPlus environment for the image.
It does a standard SFTPPlus installation where the SSH keys are generated each
time the image is created and FTPS and HTTPS are using self-signed
certificates.


Step-by-step guide
------------------

* We assume a working Docker setup, we used version 17.06.0-ce.

* Clone this repo.

* Download and copy in this directory the Alpine release for SFTPPlus.

* Adjust `SFTPPLUS_VERSION` in `Dockerfile` to match the version which was
  dowloaded.

* From inside this directory build the `sftpplus` container with::

    docker build -t sftpplus .

* If successful, you may start the new Docker container with::

    docker run sftpplus
