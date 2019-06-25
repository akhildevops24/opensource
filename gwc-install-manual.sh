#Initial setup
sudo apt-get -y update
sudo apt-get -y install mono-complete #Mono is required for kraken
sudo apt-get -y install unzip
sudo apt-get -y install xmlstarlet #for xml replacment
sudo apt-get -y install systemd


javaLatest="http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz"
tomcat8='http://httpd-mirror.sergal.org/apache/tomcat/tomcat-8/v8.5.20/bin/apache-tomcat-8.5.20.tar.gz'



#Defining few folders:
workspace='/home/geodevadmin'
gwcfolder='/home/geodevadmin/gwc'
downloadfolder='/home/geodevadmin/download'
#tomcatfolder='/opt/apache-tomcat-6.0.53'
tomcatpath='/opt/apache-tomcat-8.5.20'
javapath='/opt/jdk1.8.0_144'
geowebcache="$tomcatpath/webapps" #/geowebcache"

## using a Data disk instead of the "OS disk"
#https://docs.microsoft.com/en-us/azure/virtual-machines/linux/add-disk
datadrive="/datadrive"
GEOWEBCACHE_CACHE_DIR="$datadrive/GWC"

#Creating necessary folders for config:
sudo mkdir $workspace/download
sudo mkdir $gwcfolder
sudo mkdir $gwcfolder/configbackup

#Downloading package
cd $downloadfolder
tmpOptFolder="$downloadfolder/tmp"
sudo mkdir -p $tmpOptFolder
sudo wget -P $downloadfolder $tomcat8
sudo wget -P $downloadfolder --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" $javaLatest
sudo wget -P $downloadfolder "https://sourceforge.net/projects/geowebcache/files/geowebcache/1.11.0/geowebcache-1.11.0-war.zip"

sudo mv apache-tomcat-8.5.20.tar.gz $tmpOptFolder
sudo mv jdk-8u144-linux-x64.tar.gz $tmpOptFolder

for i in $(ls $tmpOptFolder); do
    echo extracting: $i
    sudo tar -xzvf "$tmpOptFolder/$i" -C "/opt"
#not required anymore since done above: sudo tar xzvf "$downloadfolder/apache-tomcat-8.5.20.tar.gz"; sudo tar xzvf "$downloadfolder/jdk-8u144-linux-x64.tar.gz"
done

cd /opt/

#sudo tar xzvf $downloadfolder/apache-tomcat-6.0.53.tar.gz #install tomcat
#sudo tar zxvf $downloadfolder/jdk-8u131-linux-x64.tar.gz #install java
#Adding folder for War extraction
#sudo mkdir $geowebcache
#cd $geowebcache
sudo unzip $downloadfolder/geowebcache-1.11.0-war.zip
sudo mv $downloadfolder/geowebcache.war $geowebcache
sudo unzip $geowebcache/geowebcache.war

############# Geowebcache config ####################
#setup Java path in tomcat: java_path="/opt/jdk1.8.0_131/bin/java"
cd $tomcatfolder/bin
sudo sed -i '93iexport PATH="/opt/jdk1.8.0_131/bin:$PATH"' catalina.sh
sudo sed -i '94iJAVA_OPTS="-server -Xmx1024M -DGEOWEBCACHE_CACHE_DIR=/home/geodevadmin/gwc"' catalina.sh

#configure Tomtcat users:
#/opt/apache-tomcat-6.0.53/conf$
cd $tomcatfolder/conf
sudo sed -i '41i<role rolename="manager"/>' tomcat-users.xml
sudo sed -i '42i<user username="tomcat" password="somerandom" roles="manager"/>' tomcat-users.xml

#starting tomcat
sudo sh /opt/apache-tomcat-6.0.53/bin/startup.sh

#Manual setup
#Create a bash script
#cat > bashsetup.bash
#sudo chmod +x geowebcacheSetup.bash


#JVM setup,manual process :
#Modify the following file :/opt/apache-tomcat-6.0.53/bin/catalina.sh
#Add the following lines:
#export PATH="/opt/jre1.6/bin:$PATH"
#JAVA_OPTS="-server -Xmx256M"

