#!/bin/bash

#this is  the shell script to install geoserver on a server with tomcat8 intstalled

echo "Deleting any old geoservers installed"

sudo rm -R /var/lib/tomcat8/webapps/geoserver
sudo rm -R /var/lib/tomcat8/webapps/geoserver.war
sudo rm -R /geoserver*

##change the URLs with the latest version
geoserverurl=http://sourceforge.net/projects/geoserver/files/GeoServer/2.14.2/geoserver-2.14.2-war.zip
sqlserverpluginurl=http://sourceforge.net/projects/geoserver/files/GeoServer/2.14.2/extensions/geoserver-2.14.2-sqlserver-plugin.zip
sqljdbcurl=http://www.java2s.com/Code/JarDownload/sqljdbc4/sqljdbc4-3.0.jar.zip

echo "Downloading latest Geoserver and its extensions"
sudo wget $geoserverurl -O geoserver-war.zip
sudo wget $sqlserverpluginurl -O geoserver-sqlserver-plugin.zip
sudo wget $sqljdbcurl -O sqljdbc.jar.zip

echo "Deleting any old geoservers installed"

sudo rm -R /var/lib/tomcat8/webapps/geoserver
sudo rm -R /var/lib/tomcat8/webapps/geoserver.war

echo "Started installing latest Geoserver"

echo "Unzipping the geoserver file"

sudo unzip -o geoserver-war.zip
sudo unzip -o geoserver-sqlserver-plugin.zip
sudo unzip -o sqljdbc.jar.zip

echo "moving the geoserver.war file to webapps folder"

sudo mv /geoserver.war /var/lib/tomcat8/webapps/

echo "sleeping for 3 Seconds"
sudo sleep 3s

echo "Restarting Tomcat"
sudo service tomcat8 restart

echo "Updating rights to move the geoserver extensions to move in geoserver/WEB-INF/lib"
sudo chown -R tomcat8:geoserver /var/lib/tomcat8/webapps/geoserver
sudo chmod -R 775 /var/lib/tomcat8/webapps/geoserver

echo "moving the extensions to geoserver/WEB-INF/lib"
sudo unzip -o geoserver-sqlserver-plugin.zip -d /var/lib/tomcat8/webapps/geoserver/WEB-INF/lib/
sudo unzip -o sqljdbc.jar.zip -d /var/lib/tomcat8/webapps/geoserver/WEB-INF/lib/

sudo chown -R tomcat8:geoserver /var/lib/tomcat8/webapps/geoserver
sudo chmod -R 775 /var/lib/tomcat8/webapps/geoserver
