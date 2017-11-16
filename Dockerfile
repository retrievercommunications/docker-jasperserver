FROM tomcat:7
MAINTAINER Nic Grange nicolas.grange@retrievercommunications.com 

ENV JASPERSERVER_VERSION 6.3.0

# Execute all in one layer so that it keeps the image as small as possible
RUN wget "http://downloads.sourceforge.net/project/jasperserver/JasperServer/JasperReports%20Server%20Community%20Edition%20$JASPERSERVER_VERSION/jasperreports-server-cp-$JASPERSERVER_VERSION-bin.zip" \
         -O /tmp/jasperserver.zip  && \
    unzip /tmp/jasperserver.zip -d /usr/src/ && \
    rm /tmp/jasperserver.zip && \
    mv /usr/src/jasperreports-server-cp-$JASPERSERVER_VERSION-bin /usr/src/jasperreports-server && \
    rm -r /usr/src/jasperreports-server/samples

# To speed up local testing
# Download manually the jasperreport server release to working dir
# Uncomment ADD & RUN commands below and comment out above RUN command
# ADD jasperreports-server-cp-6.3.0-bin.zip /tmp/jasperserver.zip
# RUN unzip /tmp/jasperserver.zip -d /usr/src/ && \
#    rm /tmp/jasperserver.zip && \
#    mv /usr/src/jasperreports-server-cp-$JASPERSERVER_VERSION-bin /usr/src/jasperreports-server && \
#    rm -r /usr/src/jasperreports-server/samples

# Used to wait for the database to start before connecting to it
# This script is from https://github.com/vishnubob/wait-for-it
# as recommended by https://docs.docker.com/compose/startup-order/
ADD wait-for-it.sh /wait-for-it.sh
RUN chmod a+x /wait-for-it.sh

# Used to bootstrap JasperServer the first time it runs and start Tomcat each
ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

# This volume allows JasperServer export zip files to be automatically imported when bootstrapping
VOLUME ["/jasperserver-import"]

# By default, JasperReports Server only comes with Postgres & MariaDB drivers
# Copy over other JBDC drivers the deploy-jdbc-jar ant task will put it in right location
ADD drivers/db2jcc4.jar /usr/src/jasperreports-server/buildomatic/conf_source/db/app-srv-jdbc-drivers/db2jcc4.jar
ADD drivers/mysql-connector-java-5.1.44-bin.jar /usr/src/jasperreports-server/buildomatic/conf_source/db/app-srv-jdbc-drivers/mysql-connector-java-5.1.44-bin.jar

# Use the minimum recommended settings to start-up
# as per http://community.jaspersoft.com/documentation/jasperreports-server-install-guide/v561/setting-jvm-options-application-servers
ENV JAVA_OPTS="-Xms1024m -Xmx2048m -XX:PermSize=32m -XX:MaxPermSize=512m -Xss2m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled"

# Wait for DB to start-up, start up JasperServer and bootstrap if required
ENTRYPOINT ["/entrypoint.sh"]

#Dummy change
