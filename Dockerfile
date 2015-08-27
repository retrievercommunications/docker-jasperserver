FROM tomcat:7
MAINTAINER Nic Grange nicolas.grange@retrievercommunications.com 
# Thanks to John Paul Alcala jp@jpalcala.com

ENV JASPERSERVER_VERSION 6.1.0

# Copy the relevant files over to the Container
ADD jasperreports-server-cp-$JASPERSERVER_VERSION-bin.zip /tmp/jasperserver.zip
ADD entrypoint.sh /entrypoint.sh

RUN apt-get update && \
    unzip /tmp/jasperserver.zip -d /usr/src/ && \
    mv /usr/src/jasperreports-server-cp-$JASPERSERVER_VERSION-bin /usr/src/jasperreports-server

ENV CATALINA_OPTS="-Xmx512m -XX:MaxPermSize=256m -XX:+UseBiasedLocking -XX:BiasedLockingStartupDelay=0 -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+DisableExplicitGC -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:+CMSParallelRemarkEnabled -XX:+UseCompressedOops -XX:+UseCMSInitiatingOccupancyOnly"

RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["run"]