#!/bin/bash
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
COMPONENT=$1

if [ "$1" = "" ]; then
    echo -e "\e31mValid options are component name or all\e[0m"
    exit 1
fi
create_server () {
    echo -ne "\e[35m$COMPONENT\e[0m Server Creation in Progress:\n"
    #Creating instance & getting private IP in variable
    PRIVATE_IP=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --tag-specifications "ResourceType=instance, Tags=[{Key=Name,Value=$COMPONENT}]" | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')
        sed -e "s/IPADDR/${PRIVATE_IP}/" -e "s/COMPONENT/$COMPONENT/" route53.json > /tmp/route53-record.json
    echo -ne "Creating Route53 A Record for \e[35m$COMPONENT\e[0m:\n"
    aws route53 change-resource-record-sets --hosted-zone-id Z08995942J9ZKS0XPUWM5 --change-batch file:///tmp/route53-record.json | jq
}

if [ "$1" == "all" ]; then
    for component in frontend mongodb catalogue redis user cart mysql shipping rabbitmq payment; do
        COMPONENT=$component
        create_server
    done
else
    create_server
fi