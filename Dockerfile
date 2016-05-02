FROM tomcat:7
MAINTAINER Nic Grange nicolas.grange@retrievercommunications.com 
# Credits need to go to John Paul Alcala jp@jpalcala.com for helping us get started

ENV JASPERSERVER_VERSION 6.1.0

# Copy the relevant files over to the Container
ADD entrypoint.sh /entrypoint.sh

# Execute all in one layer so that it keeps the image as small as possible
RUN wget "http://downloads.sourceforge.net/project/jasperserver/JasperServer/JasperReports%20Server%20Community%20Edition%20$JASPERSERVER_VERSION/jasperreports-server-cp-$JASPERSERVER_VERSION-bin.zip" \
         -O /tmp/jasperserver.zip  && \
    unzip /tmp/jasperserver.zip -d /usr/src/ && \
    rm /tmp/jasperserver.zip && \
    mv /usr/src/jasperreports-server-cp-$JASPERSERVER_VERSION-bin /usr/src/jasperreports-server && \
    rm -r /usr/src/jasperreports-server/samples

ENV CATALINA_OPTS="-Xmx512m -XX:MaxPermSize=256m -XX:+UseBiasedLocking -XX:BiasedLockingStartupDelay=0 -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+DisableExplicitGC -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:+CMSParallelRemarkEnabled -XX:+UseCompressedOops -XX:+UseCMSInitiatingOccupancyOnly"

RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["run"]