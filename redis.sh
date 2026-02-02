#!/bin/bash

Userid=$(id -u)
LOG_FOLDER=/var/log/ShellScript
LOG_FILE=/var/log/ShellScript/$0.log
DIR=/home/ec2-user/RoboShop-ShellScript




if [ $Userid -ne 0 ]; then
 
   echo "please run the script with root access: $0" | tee -a $0.log
   exit 1
fi

mkdir -p $LOG_FOLDER

VALIDATE() {
    if [ $? -ne 0 ]; then
     
     echo "$2....Failure"
    else
     echo "$2....Success"
     fi
}

dnf module disable redis -y
VALIDATE $? "Disable module redis"

dnf module enable redis:7 -y
VALIDATE $? "Enable module redis 7"

dnf install redis -y 
VALIDATE $? "Install redis 7"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf

systemctl enable redis 
VALIDATE $? "enable systemctl redis service"

systemctl start redis 
VALIDATE $? "start systemctl redis service"