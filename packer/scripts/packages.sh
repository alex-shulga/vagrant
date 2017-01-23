#!/usr/bin/env bash

#set right timezone
echo "================================================================================================================="
echo "Set right timezone"
echo "================================================================================================================="
sudo timedatectl set-timezone Europe/Kiev

# add ppa to install current versions of nodejs
apt-get install -y python-software-properties software-properties-common

add-apt-repository -y ppa:chris-lea/node.js

apt-get update

echo "================================================================================================================="
echo "Install RabbitMQ"
sudo mkdir /var/lib/rabbitmq
apt-get install -y rabbitmq-server
rabbitmq-plugins enable rabbitmq_management
touch /etc/rabbitmq/rabbitmq.config
echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config

echo "================================================================================================================="
echo "Install MC"
sudo apt-get install -y mc

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password vagrant'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password vagrant'


echo "================================================================================================================="
echo "Install Apache"
apt-get install -y apache2 php5
# Change apache to run as vagrant:vagrant
sed -i s/www-data/vagrant/ /etc/apache2/envvars

# Fix apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message
echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/fqdn.conf
sudo a2enconf fqdn

#Enable apache modules
a2enmod rewrite auth_digest authn_anon authn_dbm authz_owner authz_groupfile authz_dbm ldap authnz_ldap include ext_filter mime_magic expires headers usertrack setenvif dav status info dav_fs vhost_alias actions speling userdir alias substitute proxy proxy_balancer proxy_ftp proxy_http proxy_ajp proxy_connect cache suexec cgi

echo "================================================================================================================="
echo "Install MySql & other useful soft"
apt-get install -y mysql-client mysql-server
apt-get install -y vim git zip unzip curl wget
apt-get install -y memcached imagemagick

echo "================================================================================================================="
echo "Install PHP5 & php modules"
apt-get install -y snmp-mibs-downloader
apt-get install -y php5
apt-get install -y php5-mysql php5-memcached php5-xdebug php5-curl php5-json php5-sqlite php5-mcrypt php5-snmp php5-gd

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

echo "================================================================================================================="
echo "Install NodeJS"
apt-get install -y nodejs
npm install -g grunt-cli
npm install -g bower
npm install -g nodeunit

#Fix stdin: is not a tty
sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

echo "================================================================================================================="
echo "Install Screen"
apt-get install -y screen