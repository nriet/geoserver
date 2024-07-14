FROM tomcat:8.5.82-jdk11-openjdk-slim-buster

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV TZ PRC

ENV GEOSERVER_VERSION 2.25.2

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
	wget -q http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-vectortiles-plugin.zip -O /tmp/geoserver-vectortiles-plugin.zip; \
	wget -q http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-netcdf-out-plugin.zip -O /tmp/geoserver-netcdf-out-plugin.zip; \
	wget -q http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-netcdf-plugin.zip -O /tmp/geoserver-netcdf-plugin.zip; \
	wget -q http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-css-plugin.zip -O /tmp/geoserver-css-plugin.zip; \
	wget -q http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-ysld-plugin.zip -O /tmp/geoserver-ysld-plugin.zip; \
	wget -q http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-wps-plugin.zip -O /tmp/geoserver-wps-plugin.zip; \
	wget -q http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-gwc-s3-plugin.zip -O /tmp/geoserver-gwc-s3-plugin.zip; \
	unzip -o /tmp/geoserver.zip -d /tmp; \
	unzip -o /tmp/geoserver-vectortiles-plugin.zip -d /tmp; \
	unzip -o /tmp/geoserver-netcdf-out-plugin.zip -d /tmp; \
	unzip -o /tmp/geoserver-netcdf-plugin.zip -d /tmp; \
	unzip -o /tmp/geoserver-css-plugin.zip -d /tmp; \
	unzip -o /tmp/geoserver-ysld-plugin.zip -d /tmp; \
	unzip -o /tmp/geoserver-wps-plugin.zip -d /tmp; \
	unzip -o /tmp/geoserver-gwc-s3-plugin.zip -d /tmp; \
	unzip -q /tmp/fonts.zip -d /usr/share/fonts/fonts-zh; \
	unzip -q /tmp/geoserver.war -d /usr/local/tomcat/webapps/ROOT; \
	mv /tmp/*.jar /usr/local/tomcat/webapps/ROOT/WEB-INF/lib; \
	rm -rf /tmp/*

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 8080

CMD ["catalina.sh", "run"]
