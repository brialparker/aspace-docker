# aspace-docker

UMD ArchivesSpace Docker

## Quick Start

```
git clone git@github.com:umd-lib/aspace-docker.git
cd aspace-docker
docker-compose up
```

### Local Hosts

To access the web interfaces for the staff and public interfaces, you will need
to add `aspace.local` and `archives.local` as aliases for `localhost` to your
`/etc/hosts` file. Then, you will be able to access the web interfaces via the
following URLs:

* Staff: <https://aspace.local/>
* Public: <https://archives.local/>

### File Sharing

Docker will need to be configured to have access to the `aspace-docker` directory
on your host machine. On Mac OS X:

1. Open the Docker Desktop **Preferences**
2. Go to the **File Sharing** tab
3. Click the **+** button
4. Navigate to the `aspace-docker` directory and click **Open**
5. Click **Apply & Restart**

## ArchivesSpace Plugins

These are listed in the [plugins](archivesspace/config/plugins) config file.

## Details

This uses Docker Compose to deploy the application. 
Included in the docker-compose.yml configuration file, there are container
definitions for:

* ArchivesSpace
* Nginx (SSL reverse proxy)
* MySQL
* Solr 

The ArchivesSpace container can also be configured to use a different database (external MySQL or embedded Derby DB), and a different Solr (external Solr or
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