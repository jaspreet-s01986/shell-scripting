#!/bin/bash


set -e # makes script to exist if any command fails rather than moving to next step

COMPONENT=mongodb
LOGFILE="/tmp/$COMPONENT.log"
MONGODB_REPO_URL="https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo"
COMPONENT_REPO="https://github.com/stans-robot-project/mongodb/archive/main.zip"
source components/common.sh

echo -n "Downloading the $COMPONENT package: "
curl -s -o /etc/yum.repos.d/mongodb.repo $MONGODB_REPO_URL
status $?
echo -n "Installing $COMPONENT: "
yum install -y mongodb-org &>> $LOGFILE
status $?

echo -n "Updating $COMPONENT Listening Address in Config File"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
status $?

echo -n "Starting $COMPONENT: "
systemctl enable mongod &>> $LOGFILE
systemctl start mongod &>> $LOGFILE
status $?

echo -n "Downloading the $COMPONENT code: "
curl -s -L -o /tmp/mongodb.zip "$COMPONENT_REPO"
status $?
cd /tmp

echo -n "Extracting the schema: "
unzip mongodb.zip &>> $LOGFILE
status $?
cd mongodb-main
echo -n "Injecting the schema: "
mongo < catalogue.js &>> $LOGFILE
mongo < users.js &>> $LOGFILE
status $?
echo -e "\e[32m -------- $COMPONENT Configured Successfully --------\e[0m"