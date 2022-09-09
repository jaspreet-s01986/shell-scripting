#!/bin/bash

if [ "$USER_ID" -ne 0 ]; then
    echo -e "\e[32mYOu need to run the script as root user\e[0m"
    exit 1
fi
