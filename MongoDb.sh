#!/bin/bash

#This Script used to created MongoDB instance

Userid=$(id -u)
LOG_FOLDER=/var/log/ShellScript
LOG_FILE=/var/log/ShellScript/$0.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"



if [ $Userid -ne 0 ]; then
 
   echo -e "$Y please run the script with root access: $0" | tee -a $LOG_FILE
   exit 1
fi

mkdir -p $LOG_FOLDER

VALIDATE() {
    if [ $? -ne 0 ]; then
     
     echo "$R $2....Failure"
    else
     echo "$G $2....Success"
     fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
VALIDATE $? "mongo.repo copy process is"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "mongodb Installation is"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "enabling mongodb service is"

systemctl start mongod &>>$LOG_FILE
VALIDATE $? "Starting mongodb service is"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOG_FILE
VALIDATE $? "Replacement of /etc/mongod.conf is"

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "Restarted mongodb service is" 