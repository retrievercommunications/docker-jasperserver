# Run JasperServer in a Docker container

The Docker Image aims to quickly get up-and-running a JasperReports Server for a development environment.

## Prerequisites

### JasperServer release

This Dockerfile downloads the Community Edition release from SourceForge at
[e.g. jasperreports-server-cp-6.1.0-bin.zip](http://downloads.sourceforge.net/project/jasperserver/JasperServer/JasperReports%20Server%20Community%20Edition%206.1.0/jasperreports-server-cp-6.1.0-bin.zip)

### Docker-compose

To install Docker-compose see their [releases page](https://github.com/docker/compose/releases). 


## Starting the Containers 

To start up the JasperServer and MySQL containers:

### Use shell scripts

* To build and start the containers in daemon mode use `./run.sh`. Please note that this can take several minutes so be patient. You only need to do it once.
* To stop and restart the containers using `./stop.sh` and `./start.sh`

### Use batch scripts

* TODO

### Using Docker-compose

* Run `docker-compose up` to run in foreground or
* Run `docker-compose up -d` to run as in daemon mode.

To stop the containers run `docker-compose stop` and `docker-compose start` to restart them.

## Login to JasperReports Web

1. Go to URL http://${dockerHost}:8080/jasperserver/
2. Login using credentials: jasperadmin/jasperadmin


## TODOs
* Clean up entrypoint.sh and add more comments
* Add Data Only container to persist MySQL data


