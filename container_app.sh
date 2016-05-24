#!/bin/sh

DEBIAN_FRONTEND=noninteractive
apt-get install -y --no-install-recommends \
python3 python3-dev python3-pip python3-lxml \
build-essential libffi-dev git \
libtiff5-dev libjpeg8-dev zlib1g-dev \
libfreetype6-dev liblcms2-dev libwebp-dev \
curl libfontconfig nodejs npm daemon
apt-get clean

ln -s /usr/bin/nodejs /usr/bin/node
npm -g install npm
npm -g install grunt-cli bower
locale-gen en_US.UTF-8

#superdesk
mkdir -p /opt/superdesk/client
cp /mnt/superdesk/server/requirements.txt /opt/superdesk/
cd /opt/superdesk/
pip3 install virtualenv
virtualenv env
. env/bin/activate
pip3 install -U -r /opt/superdesk/requirements.txt

cp /mnt/superdesk/client/package.json /opt/superdesk/client/
cd /opt/superdesk/client && npm install

cp /mnt/superdesk/client/bower.json /opt/superdesk/client/
cp /mnt/superdesk/client/.bowerrc /opt/superdesk/client/
cd /opt/superdesk/client && bower --allow-root install

cp -r /mnt/superdesk/server/. /opt/superdesk/
cp -r /mnt/superdesk/client/ /opt/superdesk/

cd /opt/superdesk/client && grunt build

#superdesk-content-api
mkdir /opt/superdesk-content-api
cp /mnt/superdesk-content-api/requirements.txt /opt/superdesk-content-api/
cd /opt/superdesk-content-api/
virtualenv env
. env/bin/activate
pip3 install -U -r /opt/superdesk-content-api/requirements.txt
cp -r /mnt/superdesk-content-api/. /opt/superdesk-content-api/

find /root/. -type d -name '.[^.]*' -prune -exec rm -r {} +
