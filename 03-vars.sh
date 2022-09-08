#!/bin/bash
a=10
b=abc
c="\$test"
user=centos
echo $a $b $c
ls -ltr /home/$USER
ls -ltr /home/${USER}

DATE=2022-09-08
echo "Good Morning, today is $DATE"
DATE_DYNAMIC=$(date +%F +%T)
echo "Good Morning, today is $DATE_DYNAMIC, a dynamic print"