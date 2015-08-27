## Run JasperServer in a Docker container
===

To start up:

* Run `docker-compose up` to run in foreground or
* Run `docker-compose up -d` to run as in daemon mode.

To install Docker-compose see their [releases page](https://github.com/docker/compose/releases).

The Dockerfile build expects that you have already downloaded 'jasperreports-server-cp-6.1.0-bin.zip' into root directory of this repo.


## Login to JasperReports Web

1. Go to URL http://${dockerHost}:8080/jasperserver/
2. Login using credentials: jasperadmin/jasperadmin

