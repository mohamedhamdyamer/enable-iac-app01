#!/bin/bash

output=`echo ctcvmware | sudo -S docker ps --all`
wc=`echo $output | grep -w my-nginx-container | wc -l`

if [[ $wc -eq 0 ]]; then
	echo "my-nginx-container --> not found."
else
	echo ctcvmware | sudo -S docker stop my-nginx-container
fi
