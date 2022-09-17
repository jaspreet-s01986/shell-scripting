#!/bin/bash
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
COMPONENT=$1
echo "$COMPONENT Server Creation in Progress: "

PRIVATE_IP=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --tag-specifications "ResourceType=instance, Tags=[{Key=Name,Value=$COMPONENT}]" | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

sed -e "s/IPADDR/${PRIVATE_IP}/" -e "s/COMPONENT/$COMPONENT/" route53.json >> /tmp/route53-record.json

echo "Reading route53.json file"
cat route53.json

echo "Reading /tmp/route53-record.json file"
cat /tmp/route53-record.json