#/bin/bash
# Correção: 1,0

read -p "Informe o arquivo: " ARQUIVO


if [ -f $ARQUIVO ]
then
	cat $ARQUIVO |sed -s 's/[[:punct:]]//g' | tr -s ' ' '\n' | sed -s '/^$/d' | sort |  uniq -c | sed -s 's/[ ]\{2,\}//g' > terms_counts_value.aux

	while read line
	do
		number=$( echo "$line" | cut -d ' ' -f1)
		word=$( echo "$line" | cut -d ' ' -f2)
		echo ${word}: ${number}
	done < terms_counts_value.aux
	
	rm terms_counts_value.aux
else
	printf "Arquivo não encontrado.\n "

fi
