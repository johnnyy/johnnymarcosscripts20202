#!/bin/bash

echo "Criando servidor de Banco de Dados..."

key_name=$1
AMI_SO="ami-03d315ad33b9d49c4"
VPC_ID=$(aws ec2 describe-vpcs --query "Vpcs[0].VpcId" --output text)
SUBNET_ID=$(aws ec2 describe-subnets --filter Name=vpc-id,Values=${VPC_ID} --query "Subnets[0].SubnetId" --output text)
SG_ID=$(aws ec2 create-security-group --description "Script SG" --group-name "johnny-sg-atv18-f" --query "GroupId" --vpc-id ${VPC_ID} --output text)


USER_DB=${2}
PASSWORD_DB=${3}


IP_PUBLIC=$(curl ifconfig.me/ip 2> /dev/null)

aws ec2 authorize-security-group-ingress --group-id ${SG_ID} --protocol tcp --port 22 --cidr ${IP_PUBLIC}/32

aws ec2 authorize-security-group-ingress --group-id ${SG_ID} --protocol tcp --port 80 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress --group-id ${SG_ID} --protocol tcp --port 3306 --source-group ${SG_ID}


# Configurando user e password
sed -i "s/CREATE USER '.*'@/CREATE USER '${USER_DB}'@/g" user_data_db.txt

sed -i "s/IDENTIFIED BY '.*';/IDENTIFIED BY '${PASSWORD_DB}';/g" user_data_db.txt

sed -i "s/TO '.*'@'%';/TO '${USER_DB}'@'%';/g" user_data_db.txt



ID_INSTANCE=$(aws ec2 run-instances --image-id ${AMI_SO}  --instance-type "t2.micro" --key-name ${key_name} --security-group-ids ${SG_ID} --subnet-id ${SUBNET_ID}  --user-data file://user_data_db.txt --query "Instances[0].InstanceId" --output text)


state=""
while [ "${state}" != "running" ]
do
	state=$(aws ec2 describe-instances --filter Name=instance-id,Values=${ID_INSTANCE} --query "Reservations[0].Instances[0].State.Name" --output text)

	sleep 5

done

# Endereço IP Privado do Banco de Dados
IP_PRIVATE=$(aws ec2 describe-instances --filters Name=instance-id,Values=${ID_INSTANCE} --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)

echo "IP Privado do Banco de Dados: ${IP_PRIVATE}"

echo ""
echo "Criando Servidor de Aplicação..."


sed -i "s/^USER=.*/USER=${USER_DB}/g" user_data_server.txt
sed -i "s/^PASSWORD=.*/PASSWORD=${PASSWORD_DB}/g" user_data_server.txt
sed -i "s/^HOST=.*/HOST=${IP_PRIVATE}/g" user_data_server.txt
sleep 45


# SERVER
ID_INSTANCE_SERVER=$(aws ec2 run-instances --image-id ${AMI_SO}  --instance-type "t2.micro" --key-name ${key_name} --security-group-ids ${SG_ID} --subnet-id ${SUBNET_ID}  --user-data file://user_data_server.txt --query "Instances[0].InstanceId" --output text)


state=""
while [ "${state}" != "running" ]
do
	state=$(aws ec2 describe-instances --filter Name=instance-id,Values=${ID_INSTANCE_SERVER} --query "Reservations[0].Instances[0].State.Name" --output text)

	sleep 5

done

IP_INSTANCE=$(aws ec2 describe-instances --filter Name=instance-id,Values=${ID_INSTANCE_SERVER} --query "Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicIp" --output text)

sleep 30

echo "IP Público do Servidor de Aplicação: ${IP_INSTANCE}"
