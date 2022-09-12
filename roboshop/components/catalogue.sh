#!/bin/bash
set -e # makes script to exist if any command fails rather than moving to next step

COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"

NODEJS_CODE="https://github.com/stans-robot-project/catalogue/archive/main.zip"
source components/common.sh

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

echo -n "Configuring $COMPONENT Service: "
sed -i -e 's/MONGO_DNSNAME/mongodb.adjclasses.int/' systemd.service
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
systemctl daemon-reload

echo -n "Enabling & Starting $COMPONENT Service: "
systemctl enable catalogue  &>> $LOGFILE
systemctl start catalogue
status $?


