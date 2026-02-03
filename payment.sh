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



dnf install python3 gcc python3-devel -y &>>$LOG_FILE
VALIDATE $? "Installing python3 is"

id roboshop &>>$LOG_FILE
if [ $? -eq 0 ]; then
   echo -e "$Y user roboshop already exists $N"
   
else
   useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
   VALIDATE $? "user create roboshop is"
fi


mkdir -p /app &>>$LOG_FILE
VALIDATE $? "directory /app is"

curl -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip  &&>>$LOG_FILE
VALIDATE $? "Curl Command is"

cd /app &>>$LOG_FILE
VALIDATE $? "Move to Dir /app is"

rm -rf /app/*

unzip /tmp/payment.zip &>>$LOG_FILE
VALIDATE $? "unzip payment is"

pip3 install -r requirements.txt $>>$LOG_FILE
VALIDATE $? "install dependencies and libraries"

cp $DIR/payment.service /etc/systemd/system/ &>>$LOG_FILE
VALIDATE $? "Copying payment service is"

systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "system daemon-reload"

systemctl enable payment &>>$LOG_FILE
VALIDATE $? "enabling payment service is"

systemctl start payment &>>$LOG_FILE
VALIDATE $? "Starting payment service is"