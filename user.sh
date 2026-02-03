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

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Disable Module Nodejs is"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "Enable Module Nodejs 20 version is"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Nodejs Installation Verison is"

id roboshop &>>LOG_FILE
if [ $? -eq 0 ]; then
   echo -e "$Y user roboshop already exists"
   
else
   useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
   VALIDATE $? "user create roboshop is"
fi


mkdir -p /app &>>$LOG_FILE
VALIDATE $? "directory /app is"

curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip   &&>>$LOG_FILE
VALIDATE $? "Curl Command is"

cd /app &>>$LOG_FILE
VALIDATE $? "Move to Dir /app is"

rm -rf /app/* 

unzip /tmp/user.zip &>>$LOG_FILE
VALIDATE $? "unzip is"

npm install &>>$LOG_FILE
VALIDATE $? "npm installation is"

cp $DIR/user.service /etc/systemd/system/ &>>$LOG_FILE
VALIDATE $? "Copying user service is"

systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "system daemon-reload"

systemctl enable user &>>$LOG_FILE
VALIDATE $? "enabling user service is"

systemctl start user &>>$LOG_FILE
VALIDATE $? "Starting user service is"

