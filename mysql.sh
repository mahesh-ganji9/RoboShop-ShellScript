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

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing Mysql server"

systemctl enable mysqld
VALIDATE $? "enable mysql systemctl service"

systemctl start mysqld  
VALIDATE $? "start systemctl mysql service"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Set mysql root pass"
