SFTPPlus Docker
===============

`Dockerfile` and related files for creating Docker containers running
Pro:Atria's SFTPPlus MFT for evaluation purpose.

`sftpplus-docker-setup.sh` is the main script which is called to create the
SFTPPlus environment for the image.
It does a standard SFTPPlus installation where the SSH keys are generated each
time the image is created. The FTPS and HTTPS are using self-signed
certificates.

Since the SSH keys and SSL certificates are automatically generated, the
`Dockerfile` presented here is not suitable for production.

It is provided as an evaluation tool.


Step-by-step guide
------------------

* We assume a working Docker setup. We used version `17.06.0-ce`.

* Clone this repo.

* Download and copy from this directory the Alpine release for SFTPPlus.

* Adjust `SFTPPLUS_VERSION` in `Dockerfile` to match the version which was
  dowloaded.

* From inside this directory build the `sftpplus` container with::

    docker build -t sftpplus .

* If successful, you may start the new Docker container with::

    docker run sftpplus


Issues and questions
--------------------

For issues and questions, please create a new Issue.
For contributions please open a Pull Request.
