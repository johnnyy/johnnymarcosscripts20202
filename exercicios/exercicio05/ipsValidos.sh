#!/bin/bash


touch validos.txt
touch invalidos.txt
while read line
do

	valido=0
	OLDIFS=$IFS
	IFS="."

	for octeto in ${line}
	do

		if [ ${octeto} -gt "255" ] ||  [ ${octeto} -lt "0" ]
		then
			valido=1
		fi
	done

	IFS=$OLDIFS

	if [ ${valido} == "1" ]
	then
		echo ${line} >> invalidos.txt
	else
		echo ${line} >> validos.txt
	fi

done < $1

echo "Endereços válidos:" > ips_classificados.txt
cat validos.txt >> ips_classificados.txt
echo "" >> ips_classificados.txt
echo "Endereços inválidos:" >> ips_classificados.txt
cat invalidos.txt >> ips_classificados.txt
rm validos.txt invalidos.txt
