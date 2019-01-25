SFTPPlus Docker
===============

This repository contains the `Dockerfile` and related files for creating Docker
containers running Pro:Atria's SFTPPlus Managed File Transfer for evaluation
purposes.

`sftpplus-docker-setup.sh` is the main script which is called to create the
SFTPPlus environment for the image.
It does a standard SFTPPlus installation where the SSH keys are generated each
time the image is created.
The FTPS and HTTPS are using self-signed certificates.

This repository is provided as an evaluation tool and the base for creating a
custom SFTPPlus image to suit your production needs.

A testing account named `test_user` and password `test_password` is created
by default.


Image Customization
-------------------

Since the default SSH keys and SSL certificates are automatically generated,
the default `Dockerfile` presented here is not suitable for production.

For production usage you should modify the files from the `configuration/`
directory to contain your own SSH keys and SSL certificates and then
modify the `server.ini` to use these files.

The default configuration will enable all the supported protocols and expose
all the ports.
You might want to disable / remove some of the services and map them to
different ports.

For production usage it is recommended to remove the `test_user` account.

The logs produced by the server are send to standard output so that they
are available to the `docker log` infrastructure.

A copy of the logs is also stored in local files, which are rotated daily
and kept for up to 30 days.
If you are using exclusively the `docker log` infrastructure,
you might want to disable local files.

For demonstration purpose, all events are also stored in a SQLite database
and available for navigation inside the Local Manager.
For a production environment this can soon grow to a significant size and
in the same time can become a performance hit.
It is recommended to either disable it or use an external MySQL database.


Pre-requisites
--------------

We assume that you already have a working Docker environment.
We used version `18.09.1`.

You should you have downloaded a SFTPPlus version,
either the trial or the full version.

This repository contains example for the following operating systems:

* RHEL 7 / CentOS 7
* Debian 8


Docker Image Creation
---------------------

* Clone this repository.

* Get your preferred SFTPPlus version.
  In this example is the link for the trial,
  but you can replace it with your full version::

    wget https://download.sftpplus.com/trial/sftpplus-rhel7-x64-trial.tar.gz

* Check the `configuration/server.ini` configuration file to match your needs.

* Adjust `SFTPPLUS_OS` and `SFTPPLUS_VERSION` in `Dockerfile`
  to match the version which was downloaded.
  The default Dockerfile from this repo will work with SFTPPlus trial version.

* From inside the main directory build the `sftpplus` image with
  (replace `3.43.1.trial` with your preferred tag)::

    docker build -t sftpplus:3.43.1.trial .

* If successful, you should see the new image available inside your Docker
  server ::

    docker images


Launching a container
---------------------

* Once you have the image created, you may start the new Docker container.
  In this example, we will run a container named `sftpplus-instance` which
  is using the `sftpplus:3.29.0` image and makes all the ports available to
  the outside world. There are a lot of services and ports::

    docker run -d --name sftpplus-instance \
        -p 10020:10020 \
        -p 10080:10080 \
        -p 10443:10443 \
        -p 10022:10022 \
        -p 10023:10023 \
        -p 10021:10021 \
        -p 10990:10990 \
        -p 10900-10910:10900-10910 \
        sftpplus:3.43.1.trial

* You can check that the container is started::

    docker ps -a

* You can check the logs with::

    docker logs sftpplus-instance

* And stop the container with::

    docker stop sftpplus-instance

* To check how the image is created, you can start with a shell and inspect
  it::

    docker run -it --name sftpplus-debug sftpplus:3.43.1 /bin/sh

* To inspect a container which is already running use::

    docker exec -it sftpplus-instance /bin/sh


Issues and questions
--------------------

For discussions, issues and questions, please create and use issues and pull requests in the Github repo.

For contributions, please feel free to open a new pull request.

Website: https://www.sftpplus.com

SFTPPlus Documentation: https://www.sftpplus.com/documentation/sftpplus/latest/
