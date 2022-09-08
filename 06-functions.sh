#!/bin/bash

fa()
{
echo "Today is $(date +%T%F)"
echo "No of open sessions are $(who | wc -l)"
echo "Function fa completed"
}

echo "Calling function"
fa
sleep 2
fa

echo $(uptime)
echo $(uptime | awk -F : '{print $1}') #prints 1st value
echo $(uptime | awk -F : '{print $4}') #prints 5th value
echo $(uptime | awk -F : '{print $NF}') #prints last value
echo $(uptime | awk -F : '{print $NF}' | awk -F , '{print $1}') #prints first value from last column

stat ()
{
    echo "Load Average from last 1 minute is $(uptime | awk -F : '{print $NF}' | awk -F , '{print $1}')"
    echo "No of open sessions are $(who | wc -l)"
    echo "Time is $(date +%F) $(date +%T)"
}

echo "Calling stat function"
stat