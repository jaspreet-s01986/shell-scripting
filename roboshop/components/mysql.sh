#!/bin/bash
set -e # makes script to exist if any command fails rather than moving to next step

COMPONENT=mysql
LOGFILE="/tmp/$COMPONENT.log"
SQL_REPO_URL="https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo"
source components/common.sh

echo -n "Configuring the $COMPONENT Repo: "
curl -s -L -o /etc/yum.repos.d/mysql.repo $SQL_REPO_URL
status $?

echo -n "Installing $COMPONENT: "
yum install mysql-community-server -y
status $?

echo -n "Enabling & Starting $COMPONENT"
systemctl enable mysqld 
systemctl start mysqld
status $?

# grep temp /var/log/mysqld.log
#( Copy that password )

# mysql_secure_installation

# mysql -uroot -pRoboShop@1
#> uninstall plugin validate_password;

# curl -s -L -o /tmp/mysql.zip "https://github.com/stans-robot-project/mysql/archive/main.zip"
# cd /tmp
# unzip mysql.zip
# cd mysql-main
# mysql -u root -pRoboShop@1 <shipping.sql


echo -e "\e[32m -------- $COMPONENT Configured Successfully --------\e[0m"