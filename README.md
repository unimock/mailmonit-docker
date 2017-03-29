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



