#!/bin/sh

echo -n 'wait for elasticsearch.'
while ! curl -sfo /dev/null 'http://127.0.0.1:9200/'; do echo -n '.' && sleep 1; done
echo "done"

cd /opt/superdesk
. env/bin/activate
honcho run python3 manage.py app:initialize_data
honcho run python3 manage.py users:create -u admin -p superdesk -e 'admin@example.com' --admin

cd /opt/superdesk-content-api
. env/bin/activate
honcho run python3 content_api_manage.py app:prepopulate
