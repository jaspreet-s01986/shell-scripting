#!/bin/bash
set -e # makes script to exist if any command fails rather than moving to next step

COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"
source components/common.sh
NODEJS_CODE="https://github.com/stans-robot-project/catalogue/archive/main.zip"
nodejs

#Calling config_service function
config_service_user
#Calling enable & start service function
enable_start_service





echo -e "\e[32m -------- $COMPONENT Configured Successfully --------\e[0m"