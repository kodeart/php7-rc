#!/usr/bin/env bash
ENV_DIR="/vagrant/vagrant-env"
PHP_RELEASE="php-7.0.0RC7"
PHP_ARCHIVE="$PHP_RELEASE.tar.gz"

apt-get update
apt-get -y dist-upgrade

apt-get install -y apache2-mpm-prefork
apt-get install -y apache2-prefork-dev
apt-get install -y libxml2-dev
apt-get install -y libcurl4-gnutls-dev
apt-get install -y curl libcurl3
apt-get install -y libpng-dev
apt-get install -y mcrypt libmcrypt-dev
apt-get install -y libreadline-dev

if [ ! -d /etc/php7 ]; then
	mkdir /etc/php7
	mkdir /etc/php7/extra
fi;

echo "==== Download & Extracting PHP7 ===="
wget -qO /root/$PHP_ARCHIVE https://downloads.php.net/~ab/$PHP_ARCHIVE
cd /root
tar -zxf $PHP_ARCHIVE

echo "==== Compiling & Installing PHP7 ===="
cd $PHP_RELEASE
$ENV_DIR/php/configure.sh
make
make install

echo "==== Setting up Webserver ===="
a2enmod rewrite
/etc/init.d/apache2 stop

rm -R /var/lock/apache2
rm /etc/apache2/envvars
cp $ENV_DIR/apache2/envvars /etc/apache2/envvars

rm "/etc/apache2/sites-enabled/000-default"
cp $ENV_DIR/apache2/vhost.conf /etc/apache2/sites-enabled/default.conf
cp $ENV_DIR/apache2/php7.conf /etc/apache2/mods-enabled/php7.conf
cp $ENV_DIR/php/php.ini /etc/php7/php.ini
/etc/init.d/apache2 start


