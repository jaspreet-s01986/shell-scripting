#!/bin/bash
set -e # makes script to exist if any command fails rather than moving to next step

COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"

NODEJS_CODE="https://github.com/stans-robot-project/catalogue/archive/main.zip"
source components/common.sh

#Calling nodejs function
nodejs

#Calling config_service function
config_service_catalogue
#Calling enable & start service function
enable_start_service

echo -e "\e[32m -------- $COMPONENT Configured Successfully --------\e[0m"



