#!/bin/bash

# Create ec2 instance using AWS CLI

Amiid=ami-0220d79f3f480ecf5 
Instancetype="t3.micro"
SGID="sg-018e4789272ba8904"
Name="Frontend"
subnetid="subnet-06a0137ee419d9703"

aws ec2 run-instances --image-id $Amiid \
--instance-type $Instancetype \
    --subnet-id $subnetid \
    --security-group-ids $SGID  \
    --tag-specifications "'ResourceType=instance,Tags=[{Key=Name,Value=$Name}]'"

