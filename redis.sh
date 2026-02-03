#!/bin/bash

Userid=$(id -u)
LOG_FOLDER=/var/log/ShellScript
LOG_FILE=/var/log/ShellScript/$0.log
DIR=$PWD
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"



if [ $Userid -ne 0 ]; then
 
   echo -e "$R please run the script with root access: $0"
   exit 1
fi

mkdir -p $LOG_FOLDER

VALIDATE() {
    if [ $? -ne 0 ]; then
     
     echo -e "$2....$R Failure $N"
    else
     echo -e "$2....$G Success $N"
     fi
}

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "Disable module redis"

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "Enable module redis 7"

dnf install redis -y &>>$LOG_FILE
VALIDATE $? "Install redis 7"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Allow remote Connections"

systemctl enable redis &>>$LOG_FILE
VALIDATE $? "enable systemctl redis service"

systemctl start redis  &>>$LOG_FILE
VALIDATE $? "start systemctl redis service"