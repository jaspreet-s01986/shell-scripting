#!/bin/bash
set -e # makes script to exist if any command fails rather than moving to next step

COMPONENT=payment
LOGFILE="/tmp/$COMPONENT.log"
source components/common.sh

echo -n "Installing Python3: "
yum install python36 gcc python3-devel -y &> $LOGFILE
status $?

#Calling create user function
create_user
#Calling Download & Extract function
download_extract

echo -n "Installing Dependencies: "
cd /home/roboshop/payment 
pip3 install -r requirements.txt &>> $LOGFILE
status $?

echo -n "Updating the App Config $COMPONENT: "
USER_ID=$(id -u roboshop)
GROUP_ID=$(id -g roboshop)
sed -i -e "/uid/ c uid = $USER_ID" -e "/gid/ c gid = $GROUP_ID" $COMPONENT.ini
status $?

config_service

echo -e "\e[32m -------- $COMPONENT Configured Successfully --------\e[0m"