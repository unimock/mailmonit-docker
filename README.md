# mailmonitor

contains:
* alpine
* supervisord
* crond
* syslogd
* postfix
* echo mailer
* nginx
* ovw service volume
* webproc


## Create image:

     ./do build                # build the image

## Create a container from the image

     vi ./docker-compose.yml   # modify the path of your local source directory in docker-compose.yml
     ./do up                   # craete a container from the image an start it 

## Work with the conatiner:

     ./do stop
     ./do start
     ./do login                # jump in to the container
     ./do rm                   # remove the container

## Installation and Configuration
```
cp docker-compose.yml-template docker-compose.yml
vi docker-compose.yml
./do up
./do logs
./do login ovw /etc/webproc.toml   # write webproc config file to the service volume
vi ./service/ovw/etc/webproc.toml  # set user and passwort for webproc
./do restart
```
Point your browser to the webproc port an configure mailmonit.

All configuration changes will be stored on your service volume in mailmonit.dat.

Point PHPServerMonitor to the nginx port for monitoring.


