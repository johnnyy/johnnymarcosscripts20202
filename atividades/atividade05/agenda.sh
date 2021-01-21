#!/bin/bash
# Correção: 1,0

[ -f usuarios.db ] || touch usuarios.db

comando=$1

case ${comando} in

	"remover")
		if [ "$#" -eq 2 ]
		then
			email=$2
			sed -i "/:${email}/d" usuarios.db
			
		else
			echo "Quantidade de parametros incorreta!"
		fi
		;;
	"adicionar") 
		if [ "$#" -eq 3 ]
		then
			name=$2
			email=$3
			echo "${name}:${email}" >> usuarios.db
			
		else
			echo "Quantidade de parametros incorreta!"
		fi
		
		;;
		
	"listar")
		[ -f usuarios.db ] && cat usuarios.db
		;;
	*)
	echo "Opção Inválida!"
	;;
esac
