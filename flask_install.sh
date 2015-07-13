#!/bin/bash
echo 'Enter Flask virtual env absolute path:'
read env_path
echo 'Enter the absolute path to create sample api code:'
read wsgi_path

##Package installation
for pkg in  python-pip python-devel 
do
  yum install -y $pkg
  if [ `echo $?` -ne 0 ]
  then
    echo "$pkg installation failed"
    exit
  fi
done

##virtualenv setup and flask installation

if [ ! -d $env_path -a ! -d $wsgi_path ]
then
  mkdir -p $env_path $wsgi_path
  if [ `echo $?` -ne 0 ]
  then
    echo "Directory creation failed, check permissions"
  fi
fi

##Configuring virtual environment and installing packages

cd $env_path
pip install virtualenv
virtualenv venv;. venv/bin/activate
pip install Flask uwsgi
if [ `echo $?` -eq 0 ]
then
echo "Flask installation completed"
else
echo "Error in installation"
fi

echo "Configuration started....."
echo "
[uwsgi]
master = true
protocal = http
http = 0.0.0.0:8080
wsgi-file = $wsgi_path/helloworld-api.py
callable = app
logto = /var/log/uwsgi/api.log
enable-threads = true
no-site=True
processes = 2
workers = 4
" >> $env_path/jupiter_uwsgi.ini

echo "
from flask import Flask
app = Flask(__name__)
@app.route('/')
def test():
    return \"Hello World!!\"

if __name__ == '__main__':
    app.run(host='`hostname -i`')
" >> $wsgi_path/helloworld-api.py

echo "Creating log directory"

mkdir -p /var/log/uwsgi/
touch /var/log/uwsgi/api.log
#
#
#echo "
#
#[Unit]
#Description=uwsgi_flask
#
#[Service]
#TimeoutStartSec=0
#ExecStart=/opt/jupiter/venv/bin/uwsgi --socket 0.0.0.0:8080 --protocol=http --file /opt/jupiter/api/helloworld-api.py --callable app --logto /var/log/uwsgi/api.log
#ExecReload=pkill uwsgi;$env_path/venv/bin/uwsgi --socket 0.0.0.0:8080 --protocol=http --file $wsgi_path/helloworld-api.py --callable app --logto /var/log/uwsgi/api.log --enable-threads
#ExecStop=pkill uwsgi
#
#[Install]
#WantedBy=multi-user.target
#
#"> /etc/systemd/system/uwsgi_flask.service

#systemctl enable /etc/systemd/system/uwsgi_flask.service
#echo "Starting wsgi service..."
#systemctl start uwsgi_flask.service

echo "
[program:uWSGI]
directory=/opt/jupiter/
command=$env_path/venv/bin/uwsgi --ini $env_path/jupiter_uwsgi.ini
autostart=true
autorestart=true
stdout_logfile=/var/log/uwsgi/api.log
redirect_stderr=True

[inet_http_server]         ; inet (TCP) server disabled by default
port=0.0.0.0:9001        ; (ip_address:port specifier, *:port for all iface)
username=admin              ; (default is no username (open server))
password=admin
" >> /etc/supervisord.conf

echo "
[Unit]
Description=Supervisor daemon

[Service]
Type=forking
ExecStart=/usr/bin/supervisord -c /etc/supervisord.conf
ExecStop=/usr/bin/supervisorctl shutdown
ExecReload=/usr/bin/supervisorctl shutdown;/usr/bin/supervisord -c /etc/supervisord.conf
User=root

[Install]
WantedBy=multi-user.target
"> /etc/systemd/system/supervisord.service
systemctl enable /etc/systemd/system/supervisord.service
