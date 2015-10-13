#!/bin/bash
#put memcached.sh in ~
#usage:
#     cd ~
#     run command : source memcached.sh
cd ~
if [ ! -d 'memcached-src' ]
  then mkdir memcached-src;
fi
cd ~/memcached-src

echo 'install gcc,g++...'
sudo apt-get build-dep gcc
sudo apt-get install build-essential

echo 'install php5 php5-dev sasl...'
sudo apt-get install php5 php5-dev
sudo apt-get install  libsasl2-dev cloog-ppl

echo 'install libmemcache...'
wget https://launchpad.net/libmemcached/1.0/1.0.16/+download/libmemcached-1.0.16.tar.gz
tar -zxvf libmemcached-1.0.16.tar.gz
cd libmemcached-1.0.16/
./configure --prefix=/usr/local/libmemcached
make
sudo make install
make clean

echo 'install php memecached extension...'
cd..
wget http://pecl.php.net/get/memcached-2.1.0.tgz
tar zxvf memcached-2.1.0.tgz
cd memcached-2.1.0
phpize5
./configure --with-libmemcached-dir=/usr/local/libmemcached --enable-memcached-sasl
make
sudo make install
make clean

echo 'edit config.d/ , add memecached.ini...'
cd /etc/php5/apache2
sudo bash -c "echo 'extension=memcached.so' >>/etc/php5/apache2/conf.d/memcached.ini"

echo 'restart service...'
sudo service apache2 restart

cd ~
rm -r memcached-src
