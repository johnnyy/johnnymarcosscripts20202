#!/bin/bash
# Correção: 0,5



echo "Relatório de Latência"

while read line
do

	avg_value=$(ping ${line} -c 5 | grep "avg" | sed -e 's/.*= //g' | cut -d '/' -f2)
	echo "${line} ${avg_value}ms"
	
done < $1
