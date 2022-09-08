#!/bin/bash

fa()
{
echo "Today is $(date +%F %T)"
echo "No of open sessions are $(who | wc -l)"
echo "Function fa completed"
}

echo "Calling function"
fa
sleep 5
fa