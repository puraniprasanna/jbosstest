#!/bin/bash
echo "Creating for dolphind virtual environment"
mkdir -p /opt/dolphind_venv 
if [ `echo $? -ne 0` ]
then
  echo "Unable to create directory, check the permissions"
  exit 1
fi
yum install -y supervisor
if [ `echo $? -ne 0` ]
then
  echo "Unable to install the package"
  exit 1
fi

cd /opt/dolphind_venv
virtualenv venv
echo "pika
coverage
mock
nose
python-coveralls
nose-testconfig
tornado
twisted
flask
flask_socketio
flask_login
xlrd
shortuuid
cassandra-driver
python-cassandra" > /tmp/requirements.txt

echo "Installing packages via pip..."

/opt/dolphind_venv/venv/bin/pip install -r /tmp/requirements.txt

if [ `echo $?` -ne 0 ]
then
  echo "pip installation failed, please try to install packages manually and proceed"
  exit 1
fi

if [ ! -d /opt/jupiter-DolphinD ]
then
  echo "Downloading dolphind package from git.."
  git clone -b development-sprint8 --single-branch http://openstack/prabahart/Jupiter-DolphinD.git /opt/jupiter-DolphinD
else
  echo "/opt/jupiter-DolphinD already exists, provide different directory"
fi

cp -rf /reference/supervisord.conf /etc/
#cp -rf /opt/jupiter-DolphinD/Jupiter/supervisord.conf /etc/

echo "
[Unit]
Description=Supervisor daemon

[Service]
Type=forking
ExecStart=/usr/bin/supervisord -c /etc/supervisord.conf
ExecStop=/usr/bin/supervisorctl -u admin -p admin shutdown
ExecReload=/usr/bin/supervisorctl -u admin -p admin shutdown;/usr/bin/supervisord -c /etc/supervisord.conf
User=root

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/supervisord.service

systemctl enable /etc/systemd/system/supervisord.service
echo "Starting supervisord process.."
systemctl restart supervisord
systemctl status supervisord
