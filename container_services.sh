#!/bin/sh

DEBIAN_FRONTEND=noninteractive
apt-get -y autoremove --purge ntpdate nginx
apt-get update
apt-get -y dist-upgrade
apt-get -y install wget exim4 software-properties-common

#elasticsearch
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/1.7/debian stable main" > /etc/apt/sources.list.d/elastic.list

#mongodb
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list

#redis
add-apt-repository -y ppa:chris-lea/redis-server

#nginx
wget -qO - http://nginx.org/keys/nginx_signing.key | sudo apt-key add -
echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" > /etc/apt/sources.list.d/nginx.list

#install
apt-get update
apt-get -y install openjdk-7-jre-headless elasticsearch libjson-perl mongodb-org-server redis-server nginx
apt-get clean

update-rc.d elasticsearch defaults
sed -i 's/#network.host: 192.168.0.1/network.host: 127.0.0.1/' /etc/elasticsearch/elasticsearch.yml
/etc/init.d/elasticsearch start

unlink /etc/nginx/conf.d/default.conf
