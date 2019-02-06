SFTPPlus Docker
===============

This repository contains the `Dockerfile` and related files for creating Docker
containers running Pro:Atria's SFTPPlus Managed File Transfer for evaluation
purposes.

`sftpplus-docker-setup.sh` is the main script which is called to create the
SFTPPlus environment for the image.
It does a standard SFTPPlus installation, generating new SSH keys each
time the image is created.
The FTPS and HTTPS services are using self-signed certificates.

This repository is provided as an evaluation tool and the base for creating a
custom SFTPPlus Docker image to suit your production needs.

A testing account named `test_user` and password `test_password` is created
by default.


Image Customization
-------------------

Since the default SSH keys and SSL certificates are automatically generated,
the default `Dockerfile` presented here is not suitable for production.

For production usage you should add your own SSH keys and SSL certificates to
the `configuration/` subdirectory. Then modify `server.ini` to use these files.

User data should be handled by a separate volume, outside of the container,
mounted from the Docker host.
This will allow the data to persist when the container no longer exists,
and also ease access to the data outside of the container.
For production usage, dedicated volumes should be used for user data.

The default configuration will enable all the supported protocols and expose
all the ports they require.
You might want to disable / remove some of the services or map them to
different ports.

For production usage it is recommended to remove the `test_user` account.

The logs produced by the server are sent to standard output, so that they
are available through `docker log`.

A copy of the logs is also stored in local files, which are rotated daily
and kept for up to 30 days.
If you are using exclusively the `docker log` infrastructure,
you should disable local log files.

For demonstration purposes, all events are also stored in an SQLite database,
making them available through the Local Manager web console.
In a production environment they can soon grow to a significant size,
becoming a performance hit.
It is recommended to either disable this or use an external MySQL database.


Pre-requisites
--------------

We assume that you already have a working Docker environment.
We used version `18.09.1`.

You should have downloaded an SFTPPlus installation package,
either the trial or the full version.

This repository contains examples for the following operating systems:

* RHEL 7 / CentOS 7
* Debian 8
* Alpine 3.7


Docker Image Creation
---------------------

* Clone this repository.

* Get your preferred SFTPPlus version.
  The following example uses the link for the RHEL 7 / CentOS 7 trial,
  but you can replace it with your full version::

    wget https://download.sftpplus.com/trial/sftpplus-rhel7-x64-trial.tar.gz

* Edit the `configuration/server.ini` file to match your needs.

* Adjust `SFTPPLUS_OS` and `SFTPPLUS_VERSION` in `Dockerfile`
  to match the downloaded version.
  The Dockerfile from this repository works with the SFTPPlus trial version too.

* From inside the main directory, build the `sftpplus` image with
  (replace `3.44.0.trial` with your preferred tag)::

    docker build --tag sftpplus:3.44.0.trial .

* If successful, you should see the new available Docker image with::

    docker images


Launching a container
---------------------

* Once the image is created, you may start a new Docker container using it.
  In the following example, we run a container named `sftpplus-trial-instance`
  using the `sftpplus:3.44.0.trial` image which publishes all its services
  to the outside world. There are a lot of services and ports open by default::

    docker run --detach --name sftpplus-trial-instance \
        --publish 10020:10020 \
        --publish 10080:10080 \
        --publish 10443:10443 \
        --publish 10022:10022 \
        --publish 10023:10023 \
        --publish 10021:10021 \
        --publish 10990:10990 \
        --publish 10900-10910:10900-10910 \
        sftpplus:3.44.0.trial

* You can check that the container is started with::

    docker ps --all

* And check the logs with::

    docker logs sftpplus-trial-instance

* To inspect a container which is already running::

    docker exec --interactive --tty sftpplus-trial-instance /bin/sh

* You can stop the container with::

    docker stop sftpplus-trial-instance

* And then remove it with::

    docker rm sftpplus-trial-instance

* To remove the trial image altogether::

    docker rmi sftpplus:3.44.0.trial


Issues and questions
--------------------

For discussions, issues, questions, etc. please create or use
issues in this GitHub repository.

For contributions, please feel free to open new pull requests.

Website: https://www.sftpplus.com

SFTPPlus Documentation: https://www.sftpplus.com/documentation/sftpplus/latest/
