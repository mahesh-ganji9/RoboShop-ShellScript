#!/bin/bash

#This Script used to created MongoDB instance

Userid=$(id -u)
LOG_FOLDER=/var/log/ShellScript
LOG_FILE=/var/log/ShellScript/$0.log



if [ $Userid -ne 0 ]; then
 
   echo "please run the script with root access: $0" | tee -a $LOG_FILE
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

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Disable Module Nodejs is"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "Enable Module Nodejs 20 version is"

dnf install nodejs -y &&>>$LOG_FILE
VALIDATE $? "Nodejs Installation Verison is"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
Validate $? "useradd roboshop is"

mkdir -p /app &&>>$LOG_FILE
Validate $? "directory /app is"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &&>>$LOG_FILE
Validate $? "Curl Command is"

cd /app &&>>$LOG_FILE
Validate $? "Move to Dir /app is"

unzip /tmp/catalogue.zip &&>>$LOG_FILE
VALIDATE $? "unzip is"

npm install &&>>$LOG_FILE
VALIDATE $? "npm installation is"

cp Catalogue.service /etc/systemd/system/ &&>>$LOG_FILE
VALIDATE $? "Copying Catalogue service is"

systemctl daemon- &&>>$LOG_FILE
VALIDATE $? "system daemon-reload"

systemctl enable catalogue &&>>$LOG_FILE
VALIDATE $? "enabling Catalogue service is"

systemctl start catalogue &&>>$LOG_FILE
VALIDATE $? "Starting Catalogue service is"

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
VALIDATE $? "mongo.repo copy process is"

dnf install mongodb-mongosh -y
VALIDATE $? "mongo installation is success"

mongosh --host MONGODB-SERVER-IPADDRESS </app/db/master-data.js
VALIDATE $? "mongodb copy process"