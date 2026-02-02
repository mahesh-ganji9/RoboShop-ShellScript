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

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing Mysql server"

systemctl enable mysqld
VALIDATE $? "enable mysql systemctl service"

systemctl start mysqld  
VALIDATE $? "start systemctl mysql service"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Set mysql root pass"
