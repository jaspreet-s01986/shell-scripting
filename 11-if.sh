#!/bin/bash
ACTION=$1

if [ "$ACTION" = "start" ]; then
    echo -e "Selected option is \e[34m start \e[0m"
elif [ "$ACTION" = "stop" ]; then               #multiple else if (elif) can be used
    echo -e "Selected option is \e[34m start \e[0m"
else
    echo -e "Valid options are \e[34m start \e[0m \e[35m stop \e[0m"
fi