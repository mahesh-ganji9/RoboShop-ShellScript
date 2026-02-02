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

cp $DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "rabbitmq copy prcoess"

dnf install rabbitmq-server -y &>>$LOG_FILE
VALIDATE $? "Installing rabbitmq server"

systemctl enable rabbitmq-server
VALIDATE $? "enable rabbitmq systemctl service"

systemctl start rabbitmq-server
VALIDATE $? "start systemctl rabbitmq service"

id roboshop

if [$? -ne 0]; then
    echo "adding user roboshop"
    rabbitmqctl add_user roboshop roboshop123
    rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
  else
    echo "user roboshop already exists
fi
    
