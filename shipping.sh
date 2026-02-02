#!/bin/bash

Userid=$(id -u)
LOG_FOLDER=/var/log/ShellScript
LOG_FILE=/var/log/ShellScript/$0.log
DIR=/home/ec2-user/RoboShop-ShellScript
MYSQL_HOST=mysql.daws88s.shop



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



dnf install maven -y &>>$LOG_FILE
VALIDATE $? "Installing maven is"

id roboshop &>>LOG_FILE
if [ $? -eq 0 ]; then
   echo "user roboshop already exists"
   
else
   useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
   VALIDATE $? "user create roboshop is"
fi


mkdir -p /app &>>$LOG_FILE
VALIDATE $? "directory /app is"

curl -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip  &&>>$LOG_FILE
VALIDATE $? "Curl Command is"

cd /app &>>$LOG_FILE
VALIDATE $? "Move to Dir /app is"

rm -rf /app/*

unzip /tmp/shipping.zip &>>$LOG_FILE
VALIDATE $? "unzip shipping is"

mvn clean package &>>$LOG_FILE
VALIDATE $? "mvn creating .jar file"

mv target/shipping-1.0.jar shipping.jar  &>>$LOG_FILE
VALIDATE $? "renaming .jar file"

cp $DIR/shipping.service /etc/systemd/system/ &>>$LOG_FILE
VALIDATE $? "Copying shipping service is"

systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "system daemon-reload"

systemctl enable shipping &>>$LOG_FILE
VALIDATE $? "enabling shipping service is"

systemctl start shipping &>>$LOG_FILE
VALIDATE $? "Starting shipping service is"

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "Installing mysql"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities'
if [ $? -ne 0 ]; then

    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql 
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql 
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql
    VALIDATE $? "Loaded data into MySQL"
  else
    echo "mysql db is already loaded"
fi

systemctl restart shipping
VALIDATE $? "Restart shipping service is"