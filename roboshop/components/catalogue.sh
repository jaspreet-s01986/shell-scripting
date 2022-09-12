#!/bin/bash
set -e # makes script to exist if any command fails rather than moving to next step

COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"
NODEJS_REPO="https://rpm.nodesource.com/setup_lts.x"
NODEJS_CODE="https://github.com/stans-robot-project/catalogue/archive/main.zip"
$APPUSER=roboshop
source components/common.sh

echo -n "Downloading NodeJS code: "
curl -sL $NODEJS_REPO | bash &> $LOGFILE
status $?
echo -n "Installing NodeJS: "
yum install nodejs -y &>> $LOGFILE
status $?
echo -n "Creating roboshop user: "
id $APPUSER &>> $LOGFILE || useradd $APPUSER &>> $LOGFILE
status $?

echo -n "Downloading $COMPONENT Repo: "
curl -s -L -o /tmp/$COMPONENT.zip $NODEJS_CODE
status $?

echo -n "Cleaning up: "
cd /home/$APPUSER && rm -rf $COMPONENT &>> $LOGFILE
status $?

echo -n "Extracting NodeJS code: "
cd /home/$APPUSER
unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE
status $?
mv $COMPONENT-main $COMPONENT && chown -R $APPUSER:$APPUSER $COMPONENT
cd $COMPONENT
echo -n "Installing NPM : "
npm install &>> $LOGFILE
status $?
# vim systemd.servce
# mv /home/roboshop/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue
# systemctl status catalogue -l

