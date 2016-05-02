#!/bin/bash

# start the JasperServer and MySQL containers
docker run -d --name jasperserver_mysql_1 -e MYSQL_ROOT_PASSWORD=mysql mysql
docker run -d --name jasperserver_jasperserver_1 -e DB_TYPE=mysql -e DB_HOST=db -e DB_USER=root -e DB_PASSWORD=mysql --link jasperserver_mysql_1:db -p 8080:8080 retriever/jasperserver
