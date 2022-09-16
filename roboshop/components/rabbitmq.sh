#!/bin/bash
set -e # makes script to exist if any command fails rather than moving to next step

COMPONENT=rabbitmq
LOGFILE="/tmp/$COMPONENT.log"
source components/common.sh

echo -n "Installing $COMPONENT Dependency Package Erlang: "
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y
status $?

echo -n "Configuring $COMPONENT Repository: "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> $LOGFILE
status $?

echo -n "Installing $COMPONENT: "
yum install rabbitmq-server -y
status $?

echo -n "Starting and Enabling $COMPONENT Service: "
systemctl enable rabbitmq-server 
systemctl start rabbitmq-server
status $?

# rabbitmqctl add_user roboshop roboshop123
# rabbitmqctl set_user_tags roboshop administrator
# rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

echo -e "\e[32m -------- $COMPONENT Configured Successfully --------\e[0m"