SFTPPlus Docker example
=======================

This repository contains a ``Dockerfile`` and related files for creating Docker
containers running Pro:Atria's SFTPPlus Managed File Transfer for evaluation
purposes.

``sftpplus-docker-setup.sh`` is the main script called to create the
SFTPPlus environment for the Docker image.
It does a standard SFTPPlus installation, generating new SSL certificates and
SSH keys each time the image is created.
The FTPS and HTTPS services are using self-signed certificates.

This repository is provided as an evaluation tool and the base for creating a
custom SFTPPlus Docker image to suit your production needs.

The default-included basic configuration enables an administrator account
named ``admin`` with password ``pass``.
The administrative web-based interface runs on port 10020, you should access it
through your browser at https://DOCKER_ADDRESS:10020.
Make sure to update the default credentials before moving a SFTPPlus Docker
image to production.

For testing the services, a testing account named ``test_user`` with password
``test_password`` is created and enabled by default.


Pre-requisites
--------------

We assume that you already have a working Docker environment.

You should have downloaded an SFTPPlus installation package,
either the trial or the full version.

This repository contains examples for the following operating systems:

* RHEL 8 / CentOS 8
* Ubuntu 20.04 / Ubuntu 22.04
* Alpine 3.16


Docker Image Creation
---------------------

* Clone this repository.

* Get your preferred SFTPPlus version.
  The following example uses the link for the generic Linux trial,
  but you can replace it with your full version download link::

    wget https://download.sftpplus.com/trial/sftpplus-lnx-x64-trial.tar.gz

* Advanced users should edit the ``configuration/server.ini`` file to match
  their needs.

* Adjust ``SFTPPLUS_PLATFORM`` and ``SFTPPLUS_VERSION`` in ``Dockerfile``
  to match the downloaded version.
  The ``Dockerfile`` from this repository works with both the trial versions
  and the full versions of SFTPPlus.

* From inside the main directory, build the ``sftpplus`` image with
  (replace ``4.0.0.trial`` with your preferred tag).
  This will create an Ubuntu based image by default::

    docker build --tag sftpplus:4.0.0.trial .

* Optionally, you can use build arguments to target a specific OS::

   docker build \
    --build-arg "target_platform=lnx-x64" \
    --build-arg "base_image=ubuntu:22.04" \
    --build-arg "sftpplus_version=trial" \
    --tag sftpplus:4.0.0.trial .

* If successful, the following should list the newly-available Docker image::

    docker images


Launching a container
---------------------

* Once the image is created, you can start a new Docker container using it.
  In the following example, we run a container named ``sftpplus-trial``
  using the ``sftpplus:4.0.0.trial`` image, which publishes its default services
  to the outside world. There are a few standard ports open by default
  (for the administrative interface, HTTPS service, SSH service, explicit FTP
  service and its passive ports range respectively)::

    docker run --detach --name sftpplus-trial \
        --publish 10020:10020 \
        --publish 10443:10443 \
        --publish 10022:10022 \
        --publish 10021:10021 \
        --publish 10900-10910:10900-10910 \
        sftpplus:4.0.0.trial

* You can check that the container is started with::

    docker ps --all

* And check its logs with::

    docker logs sftpplus-trial

If everything looks fine, you should be able to access the administrative
web-based interface on port 10020, e.g. at https://DOCKER_ADDRESS:10020. Also,
some services are enable by default, e.g. the HTTPS client at
https://DOCKER_ADDRESS:10443.

* To inspect a container which is already running::

    docker exec --interactive --tty sftpplus-trial /bin/sh

* You can stop the container with::

    docker stop sftpplus-trial

* And then remove it with::

    docker rm sftpplus-trial

* To remove the trial image altogether::

    docker rmi sftpplus:4.0.0.trial


Image Customization
-------------------

Since the default SSH keys and SSL certificates are automatically generated,
the default ``Dockerfile`` presented here is not suitable for production.

For production usage, replace the default ``configuration/server.ini`` file
and add your own SSH keys and SSL certificates to the ``configuration/``
subdirectory.
You can also include the contents of the certificates and keys in the
configuration file.

The default configuration only enables a number of supported protocols,
exposing their required ports.
You might want to disable / remove some of the services, or map them to
different ports.

For production usage, it is recommended to update the password for the
``admin`` account and remove the ``test_user`` account.

The logs produced by the server are sent to standard output only, so that they
are available through ``docker log``. All local logs are disabled.

User data should be handled by a separate volume, outside of the container,
mounted from the Docker host.
This will allow the data to persist when the container no longer exists,
and also ease access to the data outside of the container.
For production usage, dedicated volumes should be used for user data.

For example, for the above Docker image, let's create a dedicated volume
before running it::

    docker volume create sftpplus_trial_storage

Then we should mount this to ``/srv/storage`` (as per the included configuration
file) when running the container::

    docker run --detach --name sftpplus-trial \
        --publish 10020:10020 \
        --publish 10443:10443 \
        --publish 10022:10022 \
        --publish 10021:10021 \
        --publish 10900-10910:10900-10910 \
        --mount source=sftpplus_trial_storage,target=/srv/storage \
        sftpplus:4.0.0.trial

Use ``docker inspect sftpplus-trial`` to verify that the volume
was created and mounted correctly. Look for the ``Mounts`` section::

    "Mounts": [
        {
            "Type": "volume",
            "Name": "sftpplus_trial_storage",
            "Source": "/var/lib/docker/volumes/sftpplus_trial_storage/_data",
            "Destination": "/srv/storage",
            "Driver": "local",
            "Mode": "",
            "RW": true,
            "Propagation": ""
        }
    ],

When you are done testing the trial container, after removing it,
you can also delete the newly-created volume with::

    docker volume rm sftpplus_trial_storage


Issues and questions
--------------------

For discussions, issues, questions, etc. please create or use
issues in this GitHub repository.

For contributions, please feel free to open new pull requests.

Website: https://www.sftpplus.com.

SFTPPlus Documentation: https://www.sftpplus.com/documentation/sftpplus/latest/.

OpenShift Image Creation
 * https://docs.openshift.com/container-platform/4.6/openshift_images/create-images.html
 * https://developers.redhat.com/blog/2020/10/26/adapting-docker-and-kubernetes-containers-to-run-on-red-hat-openshift-container-platform/
