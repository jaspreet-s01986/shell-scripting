#!/bin/bash
set -e # makes script to exist if any command fails rather than moving to next step

COMPONENT=redis
LOGFILE="/tmp/$COMPONENT.log"

source components/common.sh

echo -n "Configuring $COMPNENT Repo: "
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo  &> $LOGFILE
status $?

echo -n "Installing $COMPNENT: "
yum install redis-6.2.7 -y  &> $LOGFILE
status $?
#2. Update the BindIP from `127.0.0.1` to `0.0.0.0` in config file `/etc/redis.conf` & `/etc/redis/redis.conf`
echo -n "Configuring $COMPNENT's config files: "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/$COMPNENT.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/$COMPNENT/$COMPNENT.conf
status $?

#Calling Enable & Start Service function
enable_start_service
echo -e "\e[32m -------- $COMPONENT Configured Successfully --------\e[0m"