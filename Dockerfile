FROM tomcat:8.5.78-jdk8-openjdk-slim-buster

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV TZ PRC

ENV GEOSERVER_VERSION 2.22.2

COPY fonts.zip /tmp

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
	wget -q https://nchc.dl.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-vectortiles-plugin.zip -O /tmp/geoserver-vectortiles-plugin.zip; \
	wget -q https://nchc.dl.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-netcdf-out-plugin.zip -O /tmp/geoserver-netcdf-out-plugin.zip; \
	unzip -q /tmp/geoserver.zip -d /tmp; \
	unzip -q /tmp/geoserver-vectortiles-plugin.zip -d /tmp; \
	unzip -q /tmp/geoserver-netcdf-out-plugin.zip -d /tmp; \
	unzip -d /usr/local/tomcat/webapps/ROOT /tmp/geoserver.war; \
	unzip -d /usr/share/fonts fonts.zip; \
	mv /tmp/*.jar /usr/local/tomcat/webapps/ROOT/WEB-INF/lib; \
	rm -rf /tmp/*

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 8080

CMD ["catalina.sh", "run"]
