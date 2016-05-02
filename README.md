# Run JasperServer in a Docker container

The Docker Image aims to quickly get up-and-running a JasperReports Server for a development environment.

## Prerequisites

### Docker-compose

To install Docker-compose see their [releases page](https://github.com/docker/compose/releases). 

## Starting the Containers 

To start up the JasperServer and MySQL containers:

* Run `docker-compose up` to run in foreground or
* Run `docker-compose up -d` to run as in daemon mode.

To stop the containers run `docker-compose stop` and `docker-compose start` to restart them.

## Login to JasperReports Web

1. Go to URL http://${dockerHost}:8080/jasperserver/
2. Login using credentials: jasperadmin/jasperadmin
