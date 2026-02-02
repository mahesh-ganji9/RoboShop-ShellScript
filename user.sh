#!/bin/bash

Userid=$(id -u)
LOG_FOLDER=/var/log/ShellScript
LOG_FILE=/var/log/ShellScript/$0.log
DIR=/home/ec2-user/RoboShop-ShellScript
MONGO_HOST=mongodb.daws88s.shop



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

