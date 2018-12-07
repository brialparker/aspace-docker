# aspace-docker

UMD ArchivesSpace Docker

## Quick Start

### Prerequisites

The following need to be setup once on the Docker host machine.

#### Local Hosts

To access the web interfaces for the staff and public interfaces, you will need
to add `aspace.local` and `archives.local` as aliases for `localhost` to your
`/etc/hosts` file, i.e.:

```
127.0.0.1       localhost aspace.local archives.local
```

#### File Sharing

Docker may need to be configured to access the `aspace-docker` directory
on your host machine. On Mac OS X:

1. Open the Docker Desktop **Preferences**
2. Go to the **File Sharing** tab
3. Click the **+** button
4. Navigate to the `aspace-docker` directory and click **Open**
5. Click **Apply & Restart**

**Note:** Docker file sharing allows access to any subdirectory (of any depth)
of any directory that is shared. So if Docker is already configured to share
a directory that contains the `aspace-docker` directory, it is not necessary
to share it again.

### Running aspace-docker

```
git clone git@github.com:umd-lib/aspace-docker.git
cd aspace-docker
docker-compose up
```

## URLs/Ports

* <https://archives.local/> - ArchivesSpace Public User Interface (PUI)
* <https://aspace.local/> - ArchivesSpace Staff Interface
* <http://localhost:8983/> - Solr instance

A MySQL client (such as MySQL Workbench) can connect to the database on
port 3306.

## ArchivesSpace Plugins

These are listed in the [plugins](archivesspace/config/plugins) config file.

## Docker Volumes

The MySQL data is stored in a Docker volume, so stopping the Docker containers
won't destroy the data. If the Docker containers are restarted (using
"docker-compose up"), the existing Solr and MySQL data will be preserved.

If the Docker containers are removed, then the Docker volumes should also
removed, as when the containers are rebuilt, the Solr container will not have
any data, but the MySQL database will.

To delete the Docker volumes:

```
docker volume rm aspace-docker_aspace aspace-docker_mysql
```

## Details

This uses Docker Compose to deploy the application.
Included in the docker-compose.yml configuration file, there are container
definitions for:

* ArchivesSpace
* Nginx (SSL reverse proxy)
* MySQL
* Solr

The ArchivesSpace container can also be configured to use a different database
(external MySQL or embedded Derby DB), and a different Solr (external Solr or
internal). The relevant settings in the docker-compose.yml file are:

```
services:
  app:
    environment:
      APPCONFIG_DB_URL: # JDBC URL to MySQL database
      APPCONFIG_ENABLE_SOLR: # true to use internal Solr, false otherwise
      APPCONFIG_SOLR_URL: # must be set if APPCONFIG_ENABLE_SOLR is false
```

To configure the Nginx proxy, see the proxy/aspace.template file. You can pass
in variables defined in the docker-compose.yml file, which are interpolated
into the Nginx's default server configuration.
