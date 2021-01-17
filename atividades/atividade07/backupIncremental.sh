#!/bin/bash


date_time="$3 $4"

datetime_sec=$(date -d "${date_time}" +%s)


for file in $( ls $1 )
do

	if [ ! -f $2/${file} ]
	then
		datetime_sec_file=$(stat $1/${file} -c %Y)
		if [ ${datetime_sec_file} -gt ${datetime_sec} ]
		then
			cp $1${file} $2
		fi
	
	fi

done
