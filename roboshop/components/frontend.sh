#!/bin/bash
set -e # makes script to exist if any command fails rather than moving to next step

COMPONENT=frontend
LOGFILE="/tmp/$COMPONENT.log"

source components/common.sh



echo -n "Installing Nginx: "
yum install nginx -y &> $LOGFILE
status $?

systemctl enable nginx &>> $LOGFILE
echo -n "Starting Nginx: "
systemctl start nginx &>> $LOGFILE

status $?

echo -n "Downloading $COMPONENT package: "
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

status $?

echo -n "Clearing Old Content: "
cd /usr/share/nginx/html
rm -rf *
status $?
echo -n "Extracting $COMPONENT package: "
unzip /tmp/frontend.zip &>> $LOGFILE

status $?
echo -n "Moving package and updating Porxy file: "
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

status $?

echo -e "\e[32m -------- $COMPONENT Configured Successfully --------\e[0m"