FROM openjdk:8-jre
LABEL maintainer="lib-ssdr@umd.edu"
ARG aspace_version=v2.7.0

ENV ARCHIVESSPACE_LOGS=/dev/null \
    ASPACE_VERSION=$aspace_version \
    LANG=C.UTF-8 \
    MYSQLJ_VERSION=5.1.39

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends git sendmail unzip

RUN cd /opt \
    && curl -LsO https://github.com/archivesspace/archivesspace/releases/download/$ASPACE_VERSION/archivesspace-$ASPACE_VERSION.zip \
    && unzip /opt/archivesspace-$ASPACE_VERSION.zip \
    && rm /opt/archivesspace-$ASPACE_VERSION.zip

RUN cd /opt/archivesspace/lib \
    && curl -LsO http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQLJ_VERSION/mysql-connector-java-$MYSQLJ_VERSION.jar

ADD config /etc/aspace
ADD plugins.sh /usr/local/bin/plugins.sh

RUN /usr/local/bin/plugins.sh
RUN /opt/archivesspace/scripts/setup-database.sh

ADD docker-startup.sh /usr/local/bin/docker-startup.sh

EXPOSE 8080 8081
HEALTHCHECK --interval=1m --timeout=5s --start-period=5m --retries=2 \
    CMD curl -f http://localhost:8089/ || exit 1

CMD ["docker-startup.sh"]
