#!/bin/bash
# Correção: 1,0
dire=$1

if [ -d ${dire} ] 
then
	size=$(du --max-depth=0 ${dire} 2> /dev/null | cut -f1)
	count=$(ls ${dire} | wc -l)
	echo "O diretório ${dire} ocupa ${size} kilobytes e tem ${count} itens."
else
	echo "${dire} não é um diretório!!!"
	
fi

