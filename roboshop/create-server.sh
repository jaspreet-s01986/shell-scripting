#!/bin/bash
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
COMPONENT=$1

create_server () {
    echo -ne "$COMPONENT Server Creation in Progress:\n"
    #Creating instance & getting private IP in variable
    PRIVATE_IP=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --tag-specifications "ResourceType=instance, Tags=[{Key=Name,Value=$COMPONENT}]" | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')
        sed -e "s/IPADDR/${PRIVATE_IP}/" -e "s/COMPONENT/$COMPONENT/" route53.json > /tmp/route53-record.json
    echo -ne "Creating Route53 A Record for $COMPONENT:\n"
    aws route53 change-resource-record-sets --hosted-zone-id Z08995942J9ZKS0XPUWM5 --change-batch file:///tmp/route53-record.json | jq
}

if [ "$?" == "all|ALL|All" ]; then
    for component in frontend123 mongodb123 catalogue123 redis123 user123 cart123 mysql123 shipping123 rabbitmq123 payment123; do
        COMPONENT=$component
        create_server
    done
else
    create_server
fi