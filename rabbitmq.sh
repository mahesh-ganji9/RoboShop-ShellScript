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
 
   echo -e "$Y please run the script with root access: $0" 
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

cp $DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "rabbitmq copy prcoess"

dnf install rabbitmq-server -y &>>$LOG_FILE
VALIDATE $? "Installing rabbitmq server"

systemctl enable rabbitmq-server &>>$LOG_FILE
VALIDATE $? "enable rabbitmq systemctl service"

systemctl start rabbitmq-server &>>$LOG_FILE
VALIDATE $? "start systemctl rabbitmq service"

id roboshop &>>$LOG_FILE

if [ $? -ne 0 ]; then
    echo "adding user roboshop"
    rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
    rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
  else
    echo "user roboshop already exists"
fi
    
