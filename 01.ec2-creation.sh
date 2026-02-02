#!/bin/bash

# Create ec2 instance using AWS CLI

AmiId=ami-0220d79f3f480ecf5 
Instancetype="t3.micro"
SGID="sg-018e4789272ba8904"
subnetid="subnet-06a0137ee419d9703"

for Instance in $@
do

Instance_ID=$(aws ec2 run-instances --image-id $AmiId \
              --instance-type $Instancetype \
              --subnet-id $subnetid \
              --security-group-ids $SGID  \
              --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$Instance}]" \
              --query 'Instances[0].InstanceId' --output text)

echo "Provide the InstanceID: $Instance_ID"

PrivateIP=$(aws ec2 describe-instances --instance-ids $Instance_ID \
    --query 'Reservations[*].Instances[*].PrivateIpAddress' \
    --output text)

echo "Print private IP: $PrivateIP"

done