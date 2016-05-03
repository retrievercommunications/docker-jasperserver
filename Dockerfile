FROM tomcat:7
MAINTAINER Nic Grange nicolas.grange@retrievercommunications.com 

ENV JASPERSERVER_VERSION 6.1.0

# Execute all in one layer so that it keeps the image as small as possible
RUN wget "http://downloads.sourceforge.net/project/jasperserver/JasperServer/JasperReports%20Server%20Community%20Edition%20$JASPERSERVER_VERSION/jasperreports-server-cp-$JASPERSERVER_VERSION-bin.zip" \
         -O /tmp/jasperserver.zip  && \
    unzip /tmp/jasperserver.zip -d /usr/src/ && \
    rm /tmp/jasperserver.zip && \
    mv /usr/src/jasperreports-server-cp-$JASPERSERVER_VERSION-bin /usr/src/jasperreports-server && \
    rm -r /usr/src/jasperreports-server/samples


# Used to wait for the database to start before connecting to it
# This script is from https://github.com/vishnubob/wait-for-it
# as recommended by https://docs.docker.com/compose/startup-order/
ADD wait-for-it.sh /wait-for-it.sh
RUN chmod a+x /wait-for-it.sh

# Used to bootstrap JasperServer the first time it runs and start Tomcat each
ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

# This volume allows JasperServer export zip files to be automatically imported when bootstrapping
VOLUME ["/import"]

# By default, JasperReports Server only comes with Postgres & MariaDB/MySQL drivers
# Copy over other JBDC drivers the deploy-jdbc-jar ant task will put it in right location
ADD db2jcc4.jar /usr/src/jasperreports-server/buildomatic/conf_source/db/app-srv-jdbc-drivers/db2jcc4.jar

# Use the minimum recommended memory to start-up
ENV CATALINA_OPTS="-Xmx512m -XX:MaxPermSize=256m -XX:+UseBiasedLocking -XX:BiasedLockingStartupDelay=0 -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+DisableExplicitGC -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:+CMSParallelRemarkEnabled -XX:+UseCompressedOops -XX:+UseCMSInitiatingOccupancyOnly"

# Wait for DB to start-up, start up JasperServer and bootstrap if required
ENTRYPOINT ["/entrypoint.sh"]