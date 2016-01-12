#!/usr/bin/env bash
ENV_DIR="/vagrant/vagrant-env"
PHP_RELEASE="php-7.0.2"
PHP_ARCHIVE="$PHP_RELEASE.tar.gz"
XDEBUG_RELEASE="xdebug-2.4.0rc3"
XDEBUG_ARCHIVE="$XDEBUG_RELEASE.tgz"

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

echo "==== Download and Extracting $PHP_RELEASE ===="
wget -qO /root/$PHP_ARCHIVE http://de1.php.net/get/$PHP_ARCHIVE/from/this/mirror
cd /root
tar -zxf $PHP_ARCHIVE

echo "==== Compiling and Installing $PHP_RELEASE ===="
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

echo "==== Installing $XDEBUG_RELEASE ===="
wget -q "http://xdebug.org/files/$XDEBUG_ARCHIVE"

# fix retarded stupid debiliated forder name
rm -rf $XDEBUG_RELEASE
mkdir $XDEBUG_RELEASE
tar -xzf $XDEBUG_ARCHIVE -C $XDEBUG_RELEASE --strip-components 1

cd $XDEBUG_RELEASE
phpize
./configure
make
cp modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20151012
cd ..
rm $XDEBUG_ARCHIVE
rm -rf $XDEBUG_RELEASE

echo "==== Installing Composer ===="
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

echo "==== Installing PHPUnit ===="
wget -q https://phar.phpunit.de/phpunit.phar
mv phpunit.phar /usr/local/bin/phpunit
chmod +x /usr/local/bin/phpunit

# start Apache again
/etc/init.d/apache2 start
