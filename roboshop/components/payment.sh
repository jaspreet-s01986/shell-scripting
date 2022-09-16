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
# echo -n "Downloading $COMPONENT package: "
# cd /home/roboshop
# curl -L -s -o /tmp/payment.zip "https://github.com/stans-robot-project/payment/archive/main.zip"
# status $?
# echo -n "Cleaning up: "
# cd /home/$APPUSER && rm -rf $COMPONENT &>> $LOGFILE
# status $?
# echo -n "Extracting $COMPONET Package: "
# unzip -o /tmp/payment.zip &>> $LOGFILE
# mv payment-main payment
# status $?

echo -n "Installing Dependencies: "
cd /home/roboshop/payment 
pip3 install -r requirements.txt &>> $LOGFILE
status $?

echo -e "\e[32m -------- $COMPONENT Configured Successfully --------\e[0m"