#!/bin/bash
echo "Criando servidor de Monitoramento em CRON..."
key_name=$1
AMI_SO="ami-03d315ad33b9d49c4"
VPC_ID=$(aws ec2 describe-vpcs --query "Vpcs[0].VpcId" --output text)
SUBNET_ID=$(aws ec2 describe-subnets --filter Name=vpc-id,Values=${VPC_ID} --query "Subnets[0].SubnetId" --output text)
SG_ID=$(aws ec2 create-security-group --description "Script SG" --group-name "johnny-sg-atv16" --query "GroupId" --vpc-id ${VPC_ID} --output text)
aws ec2 authorize-security-group-ingress --group-id ${SG_ID} --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id ${SG_ID} --protocol tcp --port 80 --cidr 0.0.0.0/0
ID_INSTANCE=$(aws ec2 run-instances --image-id ${AMI_SO}  --instance-type "t2.micro" --key-name ${key_name} --security-group-ids ${SG_ID} --subnet-id ${SUBNET_ID}  --user-data file://initial_script.txt --query "Instances[0].InstanceId" --output text)

state=""
while [ "${state}" != "running" ]
do
	state=$(aws ec2 describe-instances --filter Name=instance-id,Values=${ID_INSTANCE} --query "Reservations[0].Instances[0].State.Name" --output text)

	sleep 5

	

done

IP_INSTANCE=$(aws ec2 describe-instances --filter Name=instance-id,Values=${ID_INSTANCE} --query "Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicIp" --output text)
sleep 40 # Para dar tempo de instalar os pacotes e passar html, pq se não, vai aparecer o padrão do Apache ou não vai aparecer a página acessada.
echo "Instância em estado \"running\""

echo "Acesse: http://${IP_INSTANCE}/"


