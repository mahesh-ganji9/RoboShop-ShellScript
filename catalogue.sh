#!/bin/bash

#This Script used to created MongoDB instance

Userid=$(id -u)
LOG_FOLDER=/var/log/ShellScript
LOG_FILE=/var/log/ShellScript/$0.log
DIR=/home/ec2-user/RoboShop-ShellScript
MONGO_HOST=mongodb.daws88s.shop

mkdir -p $LOG_FOLDER

if [ $Userid -ne 0 ]; then
 
   echo "please run the script with root access: $0" | tee -a $LOG_FILE
   exit 1
fi

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

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Nodejs Installation Verison is"

id roboshop &>>LOG_FILE
if [ $? -eq 0 ]; then
   echo "user roboshop already exists"
   
else
   useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
   VALIDATE $? "user create roboshop is"
fi


mkdir -p /app &>>$LOG_FILE
VALIDATE $? "directory /app is"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &&>>$LOG_FILE
VALIDATE $? "Curl Command is"

cd /app &>>$LOG_FILE
VALIDATE $? "Move to Dir /app is"

rm -rf /app/* 

unzip /tmp/catalogue.zip &>>$LOG_FILE
VALIDATE $? "unzip is"

npm install &>>$LOG_FILE
VALIDATE $? "npm installation is"

cp $DIR/Catalogue.service /etc/systemd/system/ &>>$LOG_FILE
VALIDATE $? "Copying Catalogue service is"

systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "system daemon-reload"

systemctl enable Catalogue &>>$LOG_FILE
VALIDATE $? "enabling Catalogue service is"

systemctl start Catalogue &>>$LOG_FILE
VALIDATE $? "Starting Catalogue service is"

cp $DIR/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
VALIDATE $? "mongo.repo copy process is"

dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "mongo installation is"

INDEX=$(mongosh --host $MONGODB_HOST --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -le 0 ]; then
    mongosh --host $MONGO_HOST </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "mongodb copy process"
  else
    echo "Mongodb products already loaded"
  fi

  