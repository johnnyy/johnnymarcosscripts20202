#!/bin/bash

for file in $( ls $1 )
do

	if [ ! -f $2${file} ]
	then
		cp $1${file} $2
	fi

done
