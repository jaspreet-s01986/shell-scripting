#!/bin/bash

fa()
{
echo "Today is $(date +%T%F)"
echo "No of open sessions are $(who | wc -l)"
echo "Function fa completed"
}

echo "Calling function"
fa
sleep 5
fa

echo $(uptime)
echo $(uptime | awk -F : '{print $1}') #prints 1st value
echo $(uptime | awk -F : '{print $4}') #prints 5th value
echo $(uptime | awk -F : '{print $NF}') #prints last value