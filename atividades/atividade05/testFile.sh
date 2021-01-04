#!/bin/bash

obj=$1

if [ -f ${obj} ]
then
	echo "É um arquivo."
elif [ -d ${obj} ]
then
	echo "É um diretório."
else
	echo "Não é diretório e não é arquivo." 
fi



if [ -r ${obj} ]
then
	echo "Tem permissão de leitura."
	
else
	echo "Não tem permissão de leitura."
	
fi



if [ -w ${obj} ]
then
	echo "Tem permissão de escrita."
	
else
	echo "Não tem permissão de escrita."
	
fi


