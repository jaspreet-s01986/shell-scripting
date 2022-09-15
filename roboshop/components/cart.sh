#!/bin/bash
set -e # makes script to exist if any command fails rather than moving to next step

COMPONENT=cart
LOGFILE="/tmp/$COMPONENT.log"
source components/common.sh

nodejs


echo -e "\e[32m -------- $COMPONENT Configured Successfully --------\e[0m"