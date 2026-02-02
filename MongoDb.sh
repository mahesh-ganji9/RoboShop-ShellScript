#!/bin/bash

#This Script used to created MongoDB instance

Userid=$(id -u)
LOG_FOLDER=/var/log/ShellScript
LOG_FILE=/var/log/ShellScript/$0.log

if [ $Userid -ne 0 ]; then
 
   echo "please run the script with root access: $0" | tee -a $0.log
fi

mkdir -p $LOG_FOLDER

VALIDATE() {
    if [$? -ne 0]; then
     
     echo "$2....Failure"
    else
     echo "$2....Success"
     fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $0.log
VALIDATE $? "mongo.repo copy process is"

dnf install mongodb-org -y &>> $0.log
VALIDATE $? "mongodb Installation is"

systemctl enable mongod &>> $0.log
VALIDATE $? "enabling mongodb service is"

systemctl start mongod &>> $0.log
VALIDATE $? "Starting mongodb service is"

sed 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $0.log
VALIDATE $? "Replacement of /etc/mongod.conf is"

systemctl restart mongod &>> $0.log
VALIDATE $? "Restarted mongodb service is" 