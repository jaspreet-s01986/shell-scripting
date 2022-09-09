#!/bin/bash
ACTION=$1

case $ACTION in
    start)
        echo "XYZ Service Starting"
        exit 0
        ;;
    stop)
        echo "XYZ Service Stopping"
        exit 0
        ;;
    *)
        echo -e "\e[34mValid options are start and stop\e[0m"
        exit 1
esac