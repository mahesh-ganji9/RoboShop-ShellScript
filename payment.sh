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



dnf install python3 gcc python3-devel -y &>>$LOG_FILE
VALIDATE $? "Installing python3 is"

id roboshop &>>$LOG_FILE
if [ $? -eq 0 ]; then
   echo "user roboshop already exists"
   
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