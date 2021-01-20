#!/bin/bash


function varre_ip(){
	echo "INICIO" > $1.txt
	for num in $( seq 255)
	do
		ping -c 1 -w 1 "$1.${num}" &> /dev/null

		if [ $? -eq 0 ] 
		then
			echo "$1.${num} on" >> $1.txt
		fi
	done
	echo "FIM" >> $1.txt


}



echo "Iniciando análise da rede $1.0/24."
echo "O resultado estará em $1.txt"
varre_ip $1 &
