#!/bin/bash


set -e # makes script to exist if any command fails rather than moving to next step

COMPONENT=mongodb
LOGFILE="/tmp/$COMPONENT.log"
MONGODB_REPO_URL="https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo"
source components/common.sh

echo -n "Downloading the $COMPONENT package: "
curl -s -o /etc/yum.repos.d/mongodb.repo $MONGODB_REPO_URL
status $?
echo -n "Installing $COMPONENT: "
yum install -y mongodb-org &>> $LOGFILE
status $?

echo -n "Updating $COMPONENT Listening Address in Config File"
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/mongod.conf
status $?

echo -n "Starting $COMPONENT: "
systemctl enable mongod &>> $LOGFILE
systemctl start mongod &>> $LOGFILE
status $?
# vim /etc/mongod.conf
# systemctl restart mongod
# curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
# cd /tmp
# unzip mongodb.zip
# cd mongodb-main
# mongo < catalogue.js
# mongo < users.js