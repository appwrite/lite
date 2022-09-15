<p align="center">
    <b>Update (2022-09-15): This repo is still a work in progress - community contribution is encouraged!</b>
    <br/>
    <br/>    
    <br/>
    <a href="https://appwrite.io" target="_blank"><img width="260" height="39" src="https://appwrite.io/images/github-logo.png" alt="Appwrite Logo"></a>
    <br />
    <br />
    <b>A complete backend solution for your [Flutter / Vue / Angular / React / iOS / Android / *ANY OTHER*] app</b>
    <br />
    <br />
</p>


[![Discord](https://img.shields.io/discord/564160730845151244?label=discord&style=flat-square)](https://appwrite.io/discord)
[![Docker Pulls](https://img.shields.io/docker/pulls/appwrite/appwrite?color=f02e65&style=flat-square)](https://hub.docker.com/r/appwrite/appwrite)
[![Build Status](https://img.shields.io/travis/com/appwrite/appwrite?style=flat-square)](https://travis-ci.com/appwrite/appwrite)
[![Twitter Account](https://img.shields.io/twitter/follow/appwrite?color=00acee&label=twitter&style=flat-square)](https://twitter.com/appwrite)
[![Follow Appwrite on StackShare](https://img.shields.io/badge/follow%20on-stackshare-blue?style=flat-square)](https://stackshare.io/appwrite)

Appwrite lite is the stripped down, single container version of Appwrite, with non essential services removed. Optimized for low resource systems.


Table of Contents:

- [Whats different](#whats-different)
- [Who is it good for](#who-is-it-good-for)
- [Installation](#installation)
- [Getting Started](#getting-started)
    
## What's different
Appwrite lite is simpler and light weight version. So we have removed few functionalities and made some fundamental changes as follows.
1. All the services are running inside a single container using supervisord.
2. Services like ClamAV antivirus and InfluxDB and Telegraf for usage stats have been removed. ClamAV has been removed as it consumes loads of memory and CPU. InfluxDB and Telegraf has been removed because of the complication of integrating these services when targetting deployment systems like Heroku and similar apps platforms.

In case of features, all the features of Appwrite is present except for usage stats and Antivirus.

## Who is it good for?
For those of you who wants minimal version of Appwrite that can be run on low res system and those who do not care about usage stats can use Appwrite-lite. Anyone who doesn't allow public to upload files to storage, so are confident that any files downloaded from storage are proper, secure files and doesn't require antivirus to protect their end users can also use this version of Appwrite-lite. Also those who want to deploy Appwrite to  platforms like Heroku or Digitalocean Apps platform and other similar platforms can also use Appwrite-lite.

## Installation

Appwritelite is simpler version of [Appwrite.io](https://appwrite.io). Running your server is as easy as running one command from your terminal.

### Create a new folder
Create a new folder, `appwrite-lite` or whatever you want to call it. And inside that folder continue creating following files.

### Create a docker-compose.yml file
```yml
version: '3'

services:  
  appwrite-lite:
    image: appwrite/appwrite-lite
    container_name: appwrite-lite
    restart: unless-stopped
    ports: 
      - 80:80
    networks:
      - appwrite-lite
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - appwrite-lite-uploads:/storage/uploads:rw
      - appwrite-lite-cache:/storage/cache:rw
      - appwrite-lite-config:/storage/config:rw
      - appwrite-lite-functions:/storage/functions:rw
      - appwrite-lite-redis:/data:rw
    depends_on:
      - mariadb
    environment:
      - _APP_ENV
      - _APP_SYSTEM_EMAIL_NAME
      - _APP_SYSTEM_EMAIL_ADDRESS
      - _APP_SYSTEM_SECURITY_EMAIL_ADDRESS
      - _APP_OPTIONS_ABUSE
      - _APP_OPTIONS_FORCE_HTTPS
      - _APP_OPENSSL_KEY_V1
      - _APP_DOMAIN
      - _APP_DOMAIN_TARGET
      - _APP_DB_HOST
      - _APP_DB_PORT
      - _APP_DB_SCHEMA
      - _APP_DB_USER
      - _APP_DB_PASS
      - _APP_SMTP_HOST
      - _APP_SMTP_PORT
      - _APP_SMTP_SECURE
      - _APP_SMTP_USERNAME
      - _APP_SMTP_PASSWORD
      - _APP_STORAGE_LIMIT
      - _APP_FUNCTIONS_TIMEOUT
      - _APP_FUNCTIONS_CONTAINERS
      - _APP_FUNCTIONS_CPUS
      - _APP_FUNCTIONS_MEMORY
      - _APP_FUNCTIONS_MEMORY_SWAP

  mariadb:
    image: appwrite/mariadb:1.2.0
    container_name: appwrite-lite-mariadb
    restart: unless-stopped
    networks:
      - appwrite-lite
    volumes:
      - appwrite-lite-mariadb:/var/lib/mysql:rw
    environment:
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_DATABASE=${_APP_DB_SCHEMA}
      - MYSQL_USER=${_APP_DB_USER}
      - MYSQL_PASSWORD=${_APP_DB_PASS}
    command: 'mysqld --innodb-flush-method=fsync'
  

networks:
  appwrite-lite:

volumes:
  appwrite-lite-mariadb:
  appwrite-lite-redis:
  appwrite-lite-cache:
  appwrite-lite-uploads:
  appwrite-lite-functions:
  appwrite-lite-config:
```

Then create .env file with the environment settings. Update appropriate configurations

```
_APP_ENV=development
_APP_SYSTEM_EMAIL_NAME=Appwritelite
_APP_SYSTEM_EMAIL_ADDRESS=team@appwrite.io
_APP_SYSTEM_SECURITY_EMAIL_ADDRESS=security@appwrite.io
_APP_OPTIONS_ABUSE=disabled
_APP_OPTIONS_FORCE_HTTPS=disabled
_APP_OPENSSL_KEY_V1=your-secret-key
_APP_DOMAIN=demo.appwrite.io
_APP_DOMAIN_TARGET=demo.appwrite.io
_APP_DB_HOST=mariadb
_APP_DB_PORT=3306
_APP_DB_SCHEMA=appwrite
_APP_DB_USER=user
_APP_DB_PASS=password
_APP_SMTP_HOST=
_APP_SMTP_PORT=
_APP_SMTP_SECURE=
_APP_SMTP_USERNAME=
_APP_SMTP_PASSWORD=
_APP_STORAGE_LIMIT=10000000
_APP_FUNCTIONS_TIMEOUT=900
_APP_FUNCTIONS_CONTAINERS=10
_APP_FUNCTIONS_CPUS=1
_APP_FUNCTIONS_MEMORY=128
_APP_FUNCTIONS_MEMORY_SWAP=128
_APP_MAINTENANCE_INTERVAL=86400
_APP_SYSTEM_RESPONSE_FORMAT=
```

### Fire up Appwrite lite server
Now you can fire up the server simply by running
```
docker-compose up -d
```

## Getting Started

Checkout the [Getting Started section in Appwrite](https://github.com/appwrite/appwrite/blob/master/README.md#getting-started).

## Viewing Logs
To view the list of all the log files available, run the following command.
```
docker-compose exec appwrite-lite ls /var/log
```

To view intdividual log files, run the following command
```
docker-compose exec appwrite-lite cat /var/log/<log-file-name>.log
```
