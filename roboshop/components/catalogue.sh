#!/bin/bash
set -e # makes script to exist if any command fails rather than moving to next step

COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"

source components/common.sh

#Calling nodejs function
nodejs



echo -e "\e[32m -------- $COMPONENT Configured Successfully --------\e[0m"



