#!/bin/bash
APPUSER=roboshop
NODEJS_REPO="https://rpm.nodesource.com/setup_lts.x"
USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
    echo -e "\e[31mYOu need to run the script as root user\e[0m"
    exit 1
fi

status () {
    if [ $? -eq 0 ]; then
        echo -e "\e[32mSUCCESS\e[0m"
    else
        echo -e "\e[31mFAILED\e[0m"
    fi
}

nodejs () {
    echo -n "Downloading NodeJS code: "
    curl -sL $NODEJS_REPO | bash &> $LOGFILE
    status $?
    echo -n "Installing NodeJS: "
    yum install nodejs -y &>> $LOGFILE
    status $?
    create_user
}

create_user () {
    echo -n "Creating roboshop user: "
    id $APPUSER &>> $LOGFILE || useradd $APPUSER &>> $LOGFILE
    status $?
}