#!/bin/sh -e

SCRIPTS_PATH=/mnt/install-scripts

apt-get update
apt-get -y install git

git clone https://github.com/superdesk/install-scripts.git $SCRIPTS_PATH
git clone https://github.com/superdesk/superdesk.git /mnt/superdesk
git clone https://github.com/superdesk/superdesk-content-api.git /mnt/superdesk-content-api

sh $SCRIPTS_PATH/container_services.sh
sh $SCRIPTS_PATH/container_app.sh

cp $SCRIPTS_PATH/files/nginx/* /etc/nginx/conf.d/
cp $SCRIPTS_PATH/files/exim4/* /etc/exim4/
cp $SCRIPTS_PATH/files/.env /opt/superdesk/
cp $SCRIPTS_PATH/files/.env /opt/superdesk-content-api/
cp $SCRIPTS_PATH/files/start.sh /opt/superdesk/
cp $SCRIPTS_PATH/files/start.sh /opt/superdesk-content-api/

cp $SCRIPTS_PATH/files/daemon /etc/init.d/superdesk
cp $SCRIPTS_PATH/files/daemon /etc/init.d/superdesk-content-api
update-rc.d superdesk defaults 90
update-rc.d superdesk-content-api defaults 90

sh $SCRIPTS_PATH/container_setup.sh

nginx -s reload
/etc/init.d/exim4 restart
/etc/init.d/superdesk start
/etc/init.d/superdesk-content-api start

echo "*********************************************************************************"
echo "Installation complete! Open in a bowser the address: http://your_server_address/"
echo "To login use default credentials:"
echo "Login: admin"
echo "Password: superdesk"
echo "*********************************************************************************"
