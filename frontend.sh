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

dnf module disable nginx -y &>>$LOG_FILE
VALIDATE $? "Disabled nginx is" 
dnf module enable nginx:1.24 -y &>>$LOG_FILE
VALIDATE $? "Module Enabilng nginx is"
dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "Installing nginx is"

systemctl enable nginx &>>$LOG_FILE
VALIDATE $? "enabling service nginx is"
systemctl start nginx &>>$LOG_FILE
VALIDATE $? "starting nginx is"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "Removing default html file is"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip  &>>$LOG_FILE
VALIDATE $? "download frontend is"

cd /usr/share/nginx/html &>>$LOG_FILE

unzip /tmp/frontend.zip  &>>$LOG_FILE
VALIDATE $? "unzip frontend zip is"

rm -rf /etc/nginx/nginx.conf
VALIDATE $? "Default nginx conf"

cp $DIR/nginx.conf /etc/nginx/
VALIDATE $? "Copied nginx.conf file"


systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "restart nginx is"