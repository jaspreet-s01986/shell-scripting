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
    #Calling create_user function
    create_user
    #Calling download_extract function
    download_extract
    echo -n "Installing NPM : "
    npm install &>> $LOGFILE
    status $?

}

create_user () {
    echo -n "Creating roboshop user: "
    id $APPUSER &>> $LOGFILE || useradd $APPUSER &>> $LOGFILE
    status $?
}

download_extract () {
    echo -n "Downloading $COMPONENT Repo: "
    curl -s -L -o /tmp/$COMPONENT.zip $NODEJS_CODE
    status $?

    echo -n "Cleaning up: "
    cd /home/$APPUSER && rm -rf $COMPONENT &>> $LOGFILE
    status $?

    echo -n "Extracting NodeJS code: "
    cd /home/$APPUSER
    unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE
    status $?
    mv $COMPONENT-main $COMPONENT && chown -R $APPUSER:$APPUSER $COMPONENT
    cd $COMPONENT
}

config_service_catalogue () {
    echo -n "Configuring $COMPONENT Service: "
    sed -i -e 's/MONGO_DNSNAME/mongodb.adjclasses.int/' systemd.service
    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    systemctl daemon-reload
    status $?
}

config_service_user () {
    echo -n "Configuring $COMPONENT Service: "
    sed -i -e 's/REDIS_ENDPOINT/redis.adjclasses.int/' -e 's/MONGO_ENDPOINT/mongodb.adjclasses.int/' systemd.service
    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    systemctl daemon-reload
    status $?
}
enable_start_service () {
    echo -n "Enabling & Starting $COMPONENT Service: "
    systemctl enable $COMPONENT  &>> $LOGFILE
    systemctl start $COMPONENT
    status $?
}