#!/bin/bash

key_name=$1

AMI_SO="ami-03d315ad33b9d49c4"
VPC_ID=$(aws ec2 describe-vpcs --query "Vpcs[0].VpcId" --output text)
SUBNET_ID=$(aws ec2 describe-subnets --filter Name=vpc-id,Values=${VPC_ID} --query "Subnets[0].SubnetId" --output text)
SG_ID=$(aws ec2 create-security-group --description "Script SG" --group-name "sgjddohnny-scriffs" --query "GroupId" --vpc-id ${VPC_ID} --output text)
aws ec2 authorize-security-group-ingress --group-id ${SG_ID} --protocol tcp --port 22
aws ec2 authorize-security-group-ingress --group-id ${SG_ID} --protocol tcp --port 80
aws ec2 run-instances --image-id ${AMI_SO}  --instance-type "t2.micro" --key-name ${key_name} --security-group-ids ${SG_ID} --subnet-id ${SUBNET_ID} --query "Reservations[0].Instances[0].NetworkInterfaces.Association.PublicIp"

