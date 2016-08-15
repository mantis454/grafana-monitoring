#!/bin/bash

#This script gets the current CPU and disk temp for the
#main Freenas server.  It's hacky at best but it works.

#The time we are going to sleep between readings
sleeptime=120

#Prepare to start the loop and warn the user
echo "Press [CTRL+C] to stop..."
while :
do
	#Now lets run script on Freenas to get temps
    hwinfo=$(ssh root@192.168.77.75 'bash -s' < /home/james/scripts/freenas.sh)

    #Lets try to find the lines we are looking for
    while read -r line; do
        #Check if we have the line we are looking for
        if [[ $line == *"cpu.0"* ]]
        then
          cpu0_temp=$line
        fi
		if [[ $line == *"cpu.1"* ]]
        then
          cpu1_temp=$line
        fi
        if [[ $line == *"WCC"* ]]
        then
          da0_temp=$line
        fi
		if [[ $line == *"Z1D4RWRE"* ]]
        then
          da1_temp=$line
        fi
		if [[ $line == *"da2"* ]]
        then
          da2_temp=$line
        fi
		if [[ $line == *"da3"* ]]
        then
          da3_temp=$line
        fi
		if [[ $line == *"da4"* ]]
        then
          da4_temp=$line
        fi
		if [[ $line == *"da5"* ]]
        then
          da5_temp=$line
        fi
		if [[ $line == *"da6"* ]]
        then
          da6_temp=$line
        fi
		if [[ $line == *"da7"* ]]
        then
          da7_temp=$line
        fi
		if [[ $line == *"da8"* ]]
        then
          da8_temp=$line
        fi
		if [[ $line == *"da9"* ]]
        then
          da9_temp=$line
        fi
		if [[ $line == *"WDH00WM0"* ]]
        then
          da10_temp=$line
        fi
		if [[ $line == *"KINGSTON"* ]]
        then
          ada0_temp=$line
        fi
        #echo "... $line ..."
    done <<< "$hwinfo"
	
	
	#clean this shit up
	cpu0_temp=$(echo $cpu0_temp | cut -c24-25)
	cpu1_temp=$(echo $cpu1_temp | cut -c24-25)
	da0_temp=$(echo $da0_temp | cut -c5-6)
	da1_temp=$(echo $da1_temp | cut -c5-6)
	da2_temp=$(echo $da2_temp | cut -c5-6)
	da3_temp=$(echo $da3_temp | cut -c5-6)
	da4_temp=$(echo $da4_temp | cut -c5-6)
	da5_temp=$(echo $da5_temp | cut -c5-6)
	da6_temp=$(echo $da6_temp | cut -c5-6)
	da7_temp=$(echo $da7_temp | cut -c5-6)
	da8_temp=$(echo $da8_temp | cut -c5-6)
	da9_temp=$(echo $da9_temp | cut -c5-6)
	da10_temp=$(echo $da10_temp | cut -c6-7)
	ada0_temp=$(echo $ada0_temp | cut -c6-7)
	echo "$da1_temp"
	
	#Write this to the database
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=0 value=$da0_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=1 value=$da1_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=2 value=$da2_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=3 value=$da3_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=4 value=$da4_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=5 value=$da5_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=6 value=$da6_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=7 value=$da7_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=8 value=$da8_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=9 value=$da9_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=10 value=$da10_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=11 value=$ada0_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=cpu_temp,cpu_number=0 value=$cpu0_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=cpu_temp,cpu_number=1 value=$cpu1_temp"	
	
	#Wait for a bit before checking again
	sleep "$sleeptime"
	
done
