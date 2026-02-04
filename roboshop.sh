#!/bin/bash
SG_ID="sg-028ddb0e8c0c3c494" #replace with your ID
AMI_ID="ami-0220d79f3f480ecf5" # replace with which operating system required
for instance in $@
do
    INSTANCE_ID=$( aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type "t3.micro" \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].InstanceId' \
    --output text )

    if [$instance == "frontend" ]; then
        IP=$(
        aws ec2 describe-instances \
        --instance-ids $INSTANCE_ID \
        --query 'Reservations[]. Instance[]. PublichIpAddress' \
        --output text)
    else
        IP=$(
        aws ec2 describe-instances \
        --instance-ids $INSTANCE_ID \
        --query 'Reservations[]. Instance[]. PublichIpAddress' \
        --output text)
    fi

    echo "IP Adress: $IP"
done
