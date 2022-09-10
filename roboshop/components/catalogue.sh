#!/bin/bash
set -e # makes script to exist if any command fails rather than moving to next step

COMPONENT=frontend
LOGFILE="/tmp/$COMPONENT.log"
NODEJS_REPO="https://rpm.nodesource.com/setup_lts.x"
NODEJS_CODE="https://github.com/stans-robot-project/catalogue/archive/main.zip"
source components/common.sh

echo -n "Downloading $COMPONENT code: "
curl -sL $NODEJS_REPO | bash
status $?
echo -n "Installing NodeJS: "
yum install nodejs -y
status $?
echo -n "Creating roboshop user: "
useradd roboshop
status $?
# echo -n "Downloading NodeJS code: "
# curl -s -L -o /tmp/catalogue.zip $NODEJS_CODE
# status $?
# echo -n "Extracting NodeJS code: "
# cd /home/roboshop
# unzip -o /tmp/catalogue.zip
# status $?
# mv catalogue-main catalogue
# cd /home/roboshop/catalogue
# npm install
# vim systemd.servce
# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue
# systemctl status catalogue -l

