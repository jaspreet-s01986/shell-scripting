#!/bin/bash
#set -e not required in this script

COMPONENT=mysql
LOGFILE="/tmp/$COMPONENT.log"
SQL_REPO_URL="https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo"
SCHEMA_URL="https://github.com/stans-robot-project/mysql/archive/main.zip"
source components/common.sh

echo -n "Configuring the $COMPONENT Repo: "
curl -s -L -o /etc/yum.repos.d/mysql.repo $SQL_REPO_URL
status $?

echo -n "Installing $COMPONENT Community Edition: "
yum install mysql-community-server -y &> $LOGFILE
status $?

echo -n "Enabling & Starting $COMPONENT: "
systemctl enable mysqld 
systemctl start mysqld
status $?

#Password needs to change only for the first time
echo "show databases" | mysql -uroot -pRoboShop@1 &>> $LOGFILE
if [ 0 -ne $? ]; then
    echo -n "Changing Default $COMPONENR Root Password: "
    DEF_ROOT_PASSWD=$(grep "temporary password" /var/log/mysqld.log | awk '{print $NF}')
    echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" > /tmp/rootpassword_change.sql
    mysql --connect-expired-password -uroot -p"$DEF_ROOT_PASSWD" < /tmp/rootpassword_change.sql
    status $?
fi


#Uninstall validate password plugin
echo "show plugins" | mysql -uroot -pRoboShop@1 2>> $LOGFILE | grep validate_password &>> $LOGFILE
if [ $? -eq 0 ]; then
    echo -n "Unistalling $COMPONENR validate password plugin: "
    echo "uninstall plugin validate_password;" > /tmp/uninstall_pw_validate.sql
    mysql -uroot -pRoboShop@1 < /tmp/uninstall_pw_validate.sql
    status $?
fi

echo -n "Downloading $COMPONENT Schema: "
curl -s -L -o /tmp/mysql.zip $SCHEMA_URL
status $?
echo -n "Extracting $COMPONET Schema: "
cd /tmp
unzip -o mysql.zip &>> $LOGFILE
status $?
echo -n "Injecting $COMPONENT Schema: "
cd mysql-main
mysql -u root -pRoboShop@1 <shipping.sql
status $?


echo -e "\e[32m -------- $COMPONENT Configured Successfully --------\e[0m"