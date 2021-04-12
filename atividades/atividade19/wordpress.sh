#!/bin/bash
# Correção: 2,5

echo "Criando instância de Banco de Dados no RDS..."



#---- CONFIGURANDO VARIAVEIS
key_name=$1
AMI_SO="ami-03d315ad33b9d49c4"
VPC_ID=$(aws ec2 describe-vpcs --query "Vpcs[0].VpcId" --output text)
SUBNET_ID=$(aws ec2 describe-subnets --filter Name=vpc-id,Values=${VPC_ID} --query "Subnets[0].SubnetId" --output text)
SG_ID=$(aws ec2 create-security-group --description "Script SG" --group-name "johnny-sg-atv19" --query "GroupId" --vpc-id ${VPC_ID} --output text)

DB_SUBNET_GROUP_NAME=$(aws rds describe-db-subnet-groups --filter Name=vpc-id,Values=${VPC_ID} --query "DBSubnetGroups[].DBSubnetGroupName" --output text
)

USER_DB=${2}
PASSWORD_DB=${3}

IP_PUBLIC=$(curl ifconfig.me/ip 2> /dev/null)

DB_NAME="script-johnny"
#-------------------------



aws ec2 authorize-security-group-ingress --group-id ${SG_ID} --protocol tcp --port 22 --cidr ${IP_PUBLIC}/32

aws ec2 authorize-security-group-ingress --group-id ${SG_ID} --protocol tcp --port 80 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress --group-id ${SG_ID} --protocol tcp --port 3306 --source-group ${SG_ID}



aws rds create-db-instance --db-instance-identifier ${DB_NAME} --engine mysql --master-username admin --master-user-password senha_segura --allocated-storage 20 --no-publicly-accessible --db-subnet-group-name ${DB_SUBNET_GROUP_NAME} --vpc-security-group-ids ${SG_ID} --db-instance-class db.t2.micro &> /dev/null


state=""
while [ "${state}" != "available" ]
do
	state=$(aws rds describe-db-instances --db-instance-identifier ${DB_NAME} --query "DBInstances[0].DBInstanceStatus" --output text)

	sleep 5

done



ENDPOINT_DB=$(aws rds describe-db-instances --db-instance-identifier ${DB_NAME} --query "DBInstances[0].Endpoint.Address" --output text)

echo "Endpoint do RDS: ${ENDPOINT_DB}"

echo ""
echo "Criando Servidor de Aplicação..."


#--------- CONFIGURANDO USER e PASSWORD
sed -i "s/^USER=.*/USER=${USER_DB}/g" user_data_server.txt
sed -i "s/^PASSWORD=.*/PASSWORD=${PASSWORD_DB}/g" user_data_server.txt
sed -i "s/^HOST=.*/HOST=${ENDPOINT_DB}/g" user_data_server.txt
# Configurando user e password
sed -i "s/CREATE USER '.*'@/CREATE USER '${USER_DB}'@/g" user_data_server.txt

sed -i "s/IDENTIFIED BY '.*';/IDENTIFIED BY '${PASSWORD_DB}';/g" user_data_server.txt

sed -i "s/TO '.*'@'%';/TO '${USER_DB}'@'%';/g" user_data_server.txt

sed -i "s/admin -h .* <</admin -h ${ENDPOINT_DB} <</g" user_data_server.txt





# SERVER
ID_INSTANCE_SERVER=$(aws ec2 run-instances --image-id ${AMI_SO}  --instance-type "t2.micro" --key-name ${key_name} --security-group-ids ${SG_ID} --subnet-id ${SUBNET_ID}  --user-data file://user_data_server.txt --query "Instances[0].InstanceId" --output text)


state=""
while [ "${state}" != "running" ]
do
	state=$(aws ec2 describe-instances --filter Name=instance-id,Values=${ID_INSTANCE_SERVER} --query "Reservations[0].Instances[0].State.Name" --output text)

	sleep 5

done

IP_INSTANCE=$(aws ec2 describe-instances --filter Name=instance-id,Values=${ID_INSTANCE_SERVER} --query "Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicIp" --output text)

sleep 50

echo "IP Público do Servidor de Aplicação: ${IP_INSTANCE}"
echo "Acesse http://${IP_INSTANCE}/wordpress para finalizar a configuração."
