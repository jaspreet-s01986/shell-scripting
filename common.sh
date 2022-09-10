#!/bin/bash

common_fun()
{
    echo -e "\e[32m==== Common Function Starts ====\e[0m"
    echo "This is common function"
    echo "This is called from common.sh"
    echo "==== Common Function Ends ===="
}

status () {
    if [ $? -eq 0 ]; then
        echo -e "\e[32mSUCCESS\e[0m"
    else
        echo -e "\e[31mFAILED\e[0m"
    fi
}