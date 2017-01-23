#!/bin/bash

cat "/vagrant/provisioning/self-promotion.txt"

if [[ -a /etc/apache2/sites-enabled/000-default.conf ]]; then
    echo "Removing default apache config."
    unlink /etc/apache2/sites-enabled/000-default.conf
fi

echo "Copying v2 apache config..."
cp /vagrant/provisioning/files/etc/apache2/sites-enabled/vagrant.conf /etc/apache2/sites-enabled/vagrant.conf

echo "Copying crontab..."
cp /vagrant/provisioning/files/etc/crontab /etc/crontab

echo "Copying bashrc..."
cp /vagrant/provisioning/files/bashrc /home/vagrant/.bashrc

echo "Copying php configs..."
cp /vagrant/provisioning/files/etc/php5/apache2/conf.d/vagrant.ini /etc/php5/apache2/conf.d/vagrant.ini
cp /vagrant/provisioning/files/etc/php5/cli/conf.d/vagrant.ini /etc/php5/cli/conf.d/vagrant.ini

echo "Creating dirs"
mkdir -p /vagrant/develop/logs/apache2

service apache2 restart

#----------------------------------------------------------------------------------------------------------------
#BACKUPS DATA
echo "Clean backups"
rm -r -f /srv/backups
mkdir -p /srv/backups

echo "Backup hosts"
cp /etc/hosts /srv/backups/hosts

echo "Backup mysql"
sudo cp -R -p /var/lib/mysql/. /tmp/mysql/
sudo chown -R vagrant:vagrant /tmp/mysql/
cd /tmp/mysql
echo "  Arhivate DB"
/usr/bin/zip -s 4g -r -UN=UTF8 -0 mysql * > /dev/null
echo "   ...done"
echo "  Copy DB"
cp /tmp/mysql/mysql.zip /srv/backups/mysql.zip
echo "   ...done"
rm -r -f /tmp/mysql
#----------------------------------------------------------------------------------------------------------------

#sudo invoke-rc.d rabbitmq-server stop
#sudo invoke-rc.d rabbitmq-server start