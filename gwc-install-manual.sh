#! /bin/sh
#Initial setup -Install the required tools.
sudo apt -y update
sudo apt -y install mono-devel #Mono is required for kraken
sudo apt -y install unzip      #unzip is required to unzip the downloaded packages
sudo apt -y install xmlstarlet #for xml replacement

sudo rm -r /datadrive
sudo rm -r /opt/apache*
sudo rm -r /opt/jdk*
sudo rm -r /home/geodevadmin/downloads

javalatest="Java Latest link"
tomcatlatest="tomcat latest link"
geowebcachelatest="https://sourceforge.net/projects/geowebcache/files/geowebcache/1.15.0/geowebcache-1.15.0-war.zip"

#gropus and users 
sudo groupadd geowebcache
sudo usermod -a -G geowebcache geodevadmin
sudo usermod -a -G geowebcache root

##Folders
sudo mkdir /datadrive
sudo mkdir /datadrive/GWC
sudo mkdir /home/geodevadmin/downloads
tomcatfolder="/opt/apache-tomcat-8.5.42"
cd /home/geodevadmin/downloads

sudo wget $javalatest
sudo wget $tomcatlatest
sudo wget $geowebcachelatest

#Extract the download folder to /opt/ folder
sudo tar -xzvf jdk-8u211-linux-x64.tar.gz -C /opt/
sudo tar -xzvf apache-tomcat-8.5.42.tar.gz -C /opt/

#Change permissions to /opt folder

sudo chown -R root:geowebcache /opt/apache-tomcat-8.5.42/
sudo chmod -R 775 /opt/apache-tomcat-8.5.42/

#Add Admin to tomcat
cd $tomcatfolder/conf
sudo sed -i '44i<role rolename="manager-gui"/>' tomcat-users.xml
sudo sed -i '45i<user username="tomcat" password="XXXXXXX" roles="manager-gui"/>' tomcat-users.xml            #Replace it with the password you need

#Change permissions to /opt folder to get same permissions for recently added file
sudo chown -R root:geowebcache /opt/apache-tomcat-8.5.42/
sudo chmod -R 775 /opt/apache-tomcat-8.5.42/

#Copy Setenv.sh to tomcat folder
#sudo mv /home/geodevadmin/downloads/setenv.sh /opt/apache-tomcat-8.5.42/bin/
cd /opt/apache-tomcat-8.5.42/bin/
sudo touch setenv.sh

echo "#! /bin/sh" >> setenv.sh

echo "# Script that will be used when starting tomcat ($CATALINA_HOME/bin/startup.sh)" >> setenv.sh

echo "export JAVA_HOME='/opt/jdk1.8.0_211'" >> setenv.sh
echo "export CATALINA_HOME='/opt/apache-tomcat-8.5.42'" >> setenv.sh

echo "GEOWEBCACHE_CACHE_DIR="/datadrive/GWC"" >> setenv.sh
echo "#Ideally the setting for staging-prod :" >> setenv.sh
echo "#export CATALINA_OPTS="-DGEOSERVER_DATA_DIR=/home/geodevadmin/MarinePress/Geoserver/data -Djava.awt.headless=true -server -Xms512m -Xmx6g -XX:SoftRefLRUPolicyMSPerMB=36000 -XX:+UseParallelGC"" >> setenv.sh
echo "#for Dev-Beta :" >> setenv.sh
echo "export CATALINA_OPTS='-DGEOWEBCACHE_CACHE_DIR=/datadrive/GWC -Djava.awt.headless=true -server -Xms256m -Xmx2048m -XX:SoftRefLRUPolicyMSPerMB=36000 -XX:+UseParallelGC'" >> setenv.sh

#Unzip Geowebcache Latest and move to tomcat/webapps location
echo "Unzipping the geowebcache and moving to webapps folder"
cd /home/geodevadmin/downloads/
sudo unzip /home/geodevadmin/downloads/geowebcache-1.15.0-war.zip
sudo mv /home/geodevadmin/downloads/geowebcache.war /opt/apache-tomcat-8.5.42/webapps/

echo "Changing Permissions on /opt Folder"
#Change permissions to /opt folder to get same permissions for recently added file
sudo chown -R root:geowebcache /opt/apache-tomcat-8.5.42/
sudo chmod -R 775 /opt/apache-tomcat-8.5.42/

##Add CORS 
cd /opt/apache-tomcat-8.5.42/conf/
sudo sed -i '447i<!-- CORS Filter   -->' web.xml
sudo sed -i '448i<filter>' web.xml
sudo sed -i '449i<filter-name>CorsFilter</filter-name>' web.xml
sudo sed -i '450i<filter-class>org.apache.catalina.filters.CorsFilter</filter-class>' web.xml
sudo sed -i '451i<init-param>' web.xml
sudo sed -i '452i<param-name>cors.allowed.origins</param-name>' web.xml
sudo sed -i '453i<param-value>*</param-value>' web.xml
sudo sed -i '454i</init-param>' web.xml
sudo sed -i '455i<init-param>' web.xml
sudo sed -i '456i<param-name>cors.allowed.headers</param-name>' web.xml
sudo sed -i '457i<param-value>Origin, Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers, Authorization, authorization</param-value>' web.xml
sudo sed -i '458i</init-param>' web.xml
sudo sed -i '459i</filter>' web.xml
sudo sed -i '460i<filter-mapping>' web.xml
sudo sed -i '461i<filter-name>CorsFilter</filter-name>' web.xml
sudo sed -i '462i<url-pattern>/*</url-pattern>' web.xml
sudo sed -i '463i</filter-mapping>' web.xml

#Stop and Start Tomcat
#echo "Stopping Tomacat"
#sudo sh /opt/apache-tomcat-8.5.42/bin/shutdown.sh
echo "sleeping for 3 Seconds"
sudo sleep 3s
echo "Starting Tomcat"
sudo sh /opt/apache-tomcat-8.5.42/bin/startup.sh




