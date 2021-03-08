#!/bin/bash
#OK

host="void"
acao="void"
ip="void"

[ -f hosts.db ] || touch hosts.db

#-----Selecao da funcao
while getopts "a:d:i:l" OPTVAR
do
	if [ "$OPTVAR" == "a" ]
	then
		host=$OPTARG
		acao="adc"
	elif [ "$OPTVAR" == "d" ]
	then
		host=$OPTARG
		acao="del" 
	elif [ "$OPTVAR" == "i" ]
	then
		ip=$OPTARG
		if [ $acao != "adc" ]
		then
			echo "Erro na entrada. Utilize \"-a hostname\ -i IP"
			exit
		fi
	elif [ "$OPTVAR" == "l" ]
	then
		acao="list"
	fi
done


if [ $acao == "void"  ] && [ $1 != "" ]
then
	acao="search"
	hostname=$1
fi


#----funcoes------
adicionar(){

	host=$1
	ip=$2
        if [ $ip != "void" ]
        then
        	echo $host:$ip >> hosts.db
	fi
}


remover(){
	hostname=$1
	sed -i -s "/^${hostname}:.*/d" hosts.db
}

listar(){
	sed -s "s/:/    /g" hosts.db
}

buscar(){
	hostname=$1
	grep -e "^$hostname:" hosts.db | sed -s "s/^.*://g" 
}

#-------escolha do método
case $acao in
	adc)
		adicionar $host $ip
		;;

	del)
		remover $host
		;;

	list)
		listar
		;;

	search)
		buscar $hostname
		;;

	*)
		echo "Utilize um comando válido"
		;;
esac
