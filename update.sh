cd /mnt/superdesk
git pull

cp -r /mnt/superdesk/server/* /opt/superdesk/
cp -r /mnt/superdesk/client/* /opt/superdesk/client/

cd /opt/superdesk
. env/bin/activate
pip3 install -U -r requirements.txt

cd /opt/superdesk/client && npm install && grunt build

/etc/init.d/superdesk reload
