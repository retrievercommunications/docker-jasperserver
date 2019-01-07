#!/bin/bash
set -e

# wait upto 30 seconds for the database to start before connecting
/wait-for-it.sh $DB_HOST:$DB_PORT -t 30

# check if we need to bootstrap the JasperServer
if [ -f "/.do_deploy_jasperserver" ]; then
    pushd /usr/src/jasperreports-server/buildomatic
    
    # Use provided configuration templates
    # Note: only works for Postgres or MySQL
    cp sample_conf/${DB_TYPE}_master.properties default_master.properties
    
    # tell the bootstrap script where to deploy the war file to
    sed -i -e "s|^appServerDir.*$|appServerDir = $CATALINA_HOME|g" default_master.properties
    
    # set all the database settings
    sed -i -e "s|^dbHost.*$|dbHost=$DB_HOST|g; s|^dbPort.*$|dbPort=$DB_PORT|g; s|^dbUsername.*$|dbUsername=$DB_USER|g; s|^dbPassword.*$|dbPassword=$DB_PASSWORD|g" default_master.properties
    
    # rename the application war so that it can be served as the default tomcat web application
    sed -i -e "s|^# webAppNameCE.*$|webAppNameCE = ROOT|g" default_master.properties

    # run the minimum bootstrap script to initial the JasperServer
    ./js-ant create-js-db || true #create database and skip it if database already exists
    ./js-ant init-js-db-ce 
    ./js-ant import-minimal-ce 
    ./js-ant deploy-webapp-ce

    # bootstrap was successful, delete file so we don't bootstrap on subsequent restarts
    rm /.do_deploy_jasperserver
    
    # Add WebServiceDataSource plugin
    wget https://community.jaspersoft.com/sites/default/files/releases/jaspersoft_webserviceds_v1.5.zip -O /tmp/jasper.zip && \
    unzip /tmp/jasper.zip -d /tmp/ && \
    cp -rfv /tmp/JRS/WEB-INF/* /usr/local/tomcat/webapps/ROOT/WEB-INF/ && \
    sed -i 's/queryLanguagesPro/queryLanguagesCe/g' /usr/local/tomcat/webapps/ROOT/WEB-INF/applicationContext-WebServiceDataSource.xml && \
    rm -rf /tmp/*

    # import any export zip files from another JasperServer

    shopt -s nullglob # handle case if no zip files found

    IMPORT_FILES=/jasperserver-import/*.zip
    for f in $IMPORT_FILES
    do
      echo "Importing $f..."
      ./js-import.sh --input-zip $f
    done

    popd
fi

# run Tomcat to start JasperServer webapp
catalina.sh run
