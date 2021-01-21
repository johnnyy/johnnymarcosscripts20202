#!/bin/bash
# Correção: 1,0

for file in $( ls $1 )
do

	ano=$(stat $1/${file}  -c %y | cut -d ' ' -f1 | cut -d '-' -f1)
	mes=$(stat $1/${file}  -c %y | cut -d ' ' -f1 | cut -d '-' -f2)
	dia=$(stat $1/${file}  -c %y | cut -d ' ' -f1 | cut -d '-' -f3)
	
	[ -d $2/${ano}/${mes}/${dia} ] ||  mkdir -p $2/${ano}/${mes}/${dia}
	cp $1/${file} $2/${ano}/${mes}/${dia}/

done
