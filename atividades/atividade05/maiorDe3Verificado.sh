#!/bin/bash
# Correção: 1,0

number1=$1
number2=$2
number3=$3


if    expr ${number1} + 1 &> /dev/null  && expr ${number2} + 1 &> /dev/null && expr ${number3} + 1 &> /dev/null 
then
	maior=${number1}
	if [ ${maior} -lt ${number2} ]
	then
		maior=${number2}
	fi
	
	if [ ${maior} -lt ${number3} ]
	then
		maior=${number3}
	fi
	
	echo "${maior}"
	
else
	echo "Opa!!! tem um valor que não é número"

fi



