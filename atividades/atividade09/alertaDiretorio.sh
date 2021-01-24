#!/bin/bash

dir_verified=$1
time_=$2
file_log="dirSensors.log"
file_history="file_history.txt"



[ -f ${file_history} ] && rm ${file_history}

touch ${file_history}

for file in $(ls ${dir_verified})
do
	datetime_sec_file=$(stat ${dir_verified}/${file} -c %Y)
	echo "${file}:${datetime_sec_file}" >> ${file_history}
done



while true

do
	sleep ${time_}
	alterados=""
	removidos=""
	adicionados=""
	datetime_exe="[$(date +'%d-%m-%Y %H:%M:%S')]"
	count_old_files=$(cat ${file_history} | wc -l )
	count_files=$(ls ${dir_verified} | wc -l )
	
	
	for file_ in $(ls ${dir_verified})
	do
		
		datetime_sec_file=$(stat ${dir_verified}/${file_} -c %Y)

		grep -e "^${file_}:" ${file_history} > /dev/null
		
		if [ $? == "0" ]
		then

			datetime_in_file_history=$(grep -e "^${file_}:" ${file_history} | cut -d ":" -f2)
			if [ ${datetime_sec_file} -gt ${datetime_in_file_history} ]
			then
				#Arquivo alterado
				sed -i -s "s/^${file_}:[0-9]*/${file_}:${datetime_sec_file}/" ${file_history}
				alterados="${file_} ${alterados}"
			fi

			
		else
			#Arquivo adicionado
			echo "${file_}:${datetime_sec_file}" >> ${file_history}
			adicionados="${file_} ${adicionados}"
		fi
		
	done
	
	for file_time in $(cat ${file_history})
	do
		#Remocao
		file_=$(echo "${file_time}" | cut -d ":" -f1 )
		if [ ! -f ${dir_verified}/${file_} ]
		then
			sed -i -s "/^${file_}:[0-9]*/d" ${file_history}
			removidos="${file_} ${removidos}"	
		fi
		
		
	done
		 
	
	if [ "${adicionados}" != "" ]
	then
		echo "${datetime_exe} Alteração! ${count_old_files}->${count_files}. Adicionados: ${adicionados}" >> ${file_log}

	fi
	
	if [ "${alterados}" != "" ]
	then
		echo "${datetime_exe} Alteração! ${count_old_files}->${count_files}. Modificados: ${alterados}" >> ${file_log}
	fi
	
	if [ "${removidos}" != "" ]
	then
		echo "${datetime_exe} Alteração! ${count_old_files}->${count_files}. Removidos: ${removidos}" >> ${file_log}
	fi



done
