#!/bin/bash
set -e

# wait upto 30 seconds for the database to start before connecting
/wait-for-it.sh $DB_HOST:$DB_PORT -t 30

# check if we need to bootstrap the JasperServer
if [ ! -d "$CATALINA_HOME/webapps/jasperserver" ]; then
    pushd /usr/src/jasperreports-server/buildomatic
    
    # only works for Postgres or MySQL
    cp sample_conf/${DB_TYPE}_master.properties default_master.properties
    sed -i -e "s|^appServerDir.*$|appServerDir = $CATALINA_HOME|g; s|^dbHost.*$|dbHost=$DB_HOST|g; s|^dbPort.*$|dbPort=$DB_PORT|g; s|^dbUsername.*$|dbUsername=$DB_USER|g; s|^dbPassword.*$|dbPassword=$DB_PASSWORD|g" default_master.properties

    ./js-ant create-js-db 
    ./js-ant init-js-db-ce 
    ./js-ant import-minimal-ce 
    ./js-ant deploy-webapp-ce
    
    popd
fi

# run Tomcat to start JasperServer webapp
catalina.sh run
