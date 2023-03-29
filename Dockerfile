FROM tomcat:8.5.78-jdk8-openjdk-slim-buster

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV TZ PRC

ENV GEOSERVER_VERSION 2.22.2

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		net-tools \
		wget \
		unzip \
		libfreetype6-dev \
		fontconfig \
	; \
	rm -rf /var/cache/apt 

RUN set -eux; \
	\
	wget -q http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip -O /tmp/geoserver.zip; \
	unzip -q /tmp/geoserver.zip -d /tmp; \
	unzip -d /usr/local/tomcat/webapps/ROOT /tmp/geoserver.war; \
	rm -rf /tmp/*

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 8080

CMD ["catalina.sh", "run"]
