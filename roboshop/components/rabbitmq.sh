#!/bin/bash
set -e # makes script to exist if any command fails rather than moving to next step

COMPONENT=rabbitmq
LOGFILE="/tmp/$COMPONENT.log"
source components/common.sh
rpm -ql erlang-23.2.6-1.el7.x86_64 &> $LOGFILE
if [ $? -ne 0 ]; then
    echo -n "Installing $COMPONENT Dependency Package Erlang: "
    yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>> $LOGFILE
    status $?
fi
echo -n "Configuring $COMPONENT Repository: "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> $LOGFILE
status $?

echo -n "Installing $COMPONENT: "
yum install rabbitmq-server -y &>> $LOGFILE
status $?

echo -n "Starting and Enabling $COMPONENT Service: "
systemctl enable rabbitmq-server 
systemctl start rabbitmq-server
status $?

rabbitmqctl list_users | grep $APPUSER  &>> $LOGFILE
if [ $? -ne 0 ]; then
    echo -n "Creating $APPUSER user for $COMPONENT: "
    rabbitmqctl add_user $APPUSER roboshop123 &>> $LOGFILE
    status $?
fi

echo -n "Configuring $APPUSER permissions for $COMPONENT: "
rabbitmqctl set_user_tags $APPUSER administrator &>> $LOGFILE
rabbitmqctl set_permissions -p / $APPUSER ".*" ".*" ".*" &>> $LOGFILE
status $?

echo -e "\e[32m -------- $COMPONENT Configured Successfully --------\e[0m"