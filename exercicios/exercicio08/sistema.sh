#!/bin/bash
# Correção: 1,0
trap "clear; echo 'Valeu, até a próxima!'; exit" 2

func_1(){
	clear
	uptime
}

func_2(){
	clear
	dmesg | tail -n 10
}

func_3(){
	clear
	vmstat 1 10
}

func_4(){
	clear
	mpstat -P ALL 1 5
}

func_5(){
	clear
	pidstat 1 5
}

func_6(){
	clear
	free -m
}

menu(){
	clear
	echo "Infome uma das opções:"
	echo "1 - Tempo ligado"
	echo "2 - Últimas mensagens do kernel"
	echo "3 - Memória virtual"
	echo "4 - Uso da CPU por núcleo"
	echo "5 - Uso da CPU por processos"
	echo "6 - Uso da memória física"
}


while true
do
	menu
	read opcao
	case $opcao in
		1) func_1 ;;
		2) func_2 ;;
		3) func_3 ;;
		4) func_4 ;;
		5) func_5 ;;
		6) func_6 ;;
		*) echo "Opção Inválida" ;;
	esac

	read op

done
