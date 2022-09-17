#!/bin/bash
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
COMPONENT=$1
echo "$COMPONENT Server Creation in Progress: "
aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro
