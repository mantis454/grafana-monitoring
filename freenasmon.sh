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
          d_WDred=$line
        fi
		if [[ $line == *"Z1D4RVYL"* ]]
        then
          d_Seag0=$line
        fi
		if [[ $line == *"W3015KFM"* ]]
        then
          d_Seag1=$line
        fi
		if [[ $line == *"W30164CV"* ]]
        then
          d_Seag2=$line
        fi
		if [[ $line == *"W3015KHJ"* ]]
        then
          d_Seag3=$line
        fi
		if [[ $line == *"W3015KBK"* ]]
        then
          d_Seag4=$line
        fi
		if [[ $line == *"WDH00WT4"* ]]
        then
          d_Seag5=$line
        fi
		if [[ $line == *"WDH00XG1"* ]]
        then
          d_Seag6=$line
        fi
		if [[ $line == *"WDH00XA7"* ]]
        then
          d_Seag7=$line
        fi
		if [[ $line == *"WDH00WM0"* ]]
        then
          d_Seag8=$line
        fi
		if [[ $line == *"KINGSTON"* ]]
        then
          d_king=$line
        fi
		if [[ $line == *"S2H7JD2B418146"* ]]
        then
          d_sams=$line
        fi
        #echo "... $line ..."
    done <<< "$hwinfo"
	
	
	#clean this shit up
	cpu0_temp=$(echo $cpu0_temp | cut -c24-25)
	cpu1_temp=$(echo $cpu1_temp | cut -c24-25)
	
	d_WDred_temp=$(echo $d_WDred | cut -d' ' -f2)
	d_Seag0_temp=$(echo $d_Seag0 | cut -d' ' -f2)
	d_Seag1_temp=$(echo $d_Seag1 | cut -d' ' -f2)
	d_Seag2_temp=$(echo $d_Seag2 | cut -d' ' -f2)
	d_Seag3_temp=$(echo $d_Seag3 | cut -d' ' -f2)
	d_Seag4_temp=$(echo $d_Seag4 | cut -d' ' -f2)
	d_Seag5_temp=$(echo $d_Seag5 | cut -d' ' -f2)
	d_Seag6_temp=$(echo $d_Seag6 | cut -d' ' -f2)
	d_Seag7_temp=$(echo $d_Seag7 | cut -d' ' -f2)
	d_Seag8_temp=$(echo $d_Seag8 | cut -d' ' -f2)
	d_king_temp=$(echo $d_king | cut -d' ' -f2)
        d_sams_temp=$(echo $d_sams | cut -d' ' -f2)
	
	d_WDred_ser=$(echo $d_WDred | cut -d' ' -f3)
	d_Seag0_ser=$(echo $d_Seag0 | cut -d' ' -f3)
	d_Seag1_ser=$(echo $d_Seag1 | cut -d' ' -f3)
	d_Seag2_ser=$(echo $d_Seag2 | cut -d' ' -f3)
	d_Seag3_ser=$(echo $d_Seag3 | cut -d' ' -f3)
	d_Seag4_ser=$(echo $d_Seag4 | cut -d' ' -f3)
	d_Seag5_ser=$(echo $d_Seag5 | cut -d' ' -f3)
	d_Seag6_ser=$(echo $d_Seag6 | cut -d' ' -f3)
	d_Seag7_ser=$(echo $d_Seag7 | cut -d' ' -f3)
	d_Seag8_ser=$(echo $d_Seag8 | cut -d' ' -f3)
	d_king_ser=$(echo $d_king | cut -d' ' -f3)
	d_sams_ser=$(echo $d_sams | cut -d' ' -f3)
	
	#Write this to the database
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=0,serial=$d_WDred_ser value=$d_WDred_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=1,serial=$d_Seag0_ser value=$d_Seag0_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=2,serial=$d_Seag1_ser value=$d_Seag1_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=3,serial=$d_Seag2_ser value=$d_Seag2_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=4,serial=$d_Seag3_ser value=$d_Seag3_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=5,serial=$d_Seag4_ser value=$d_Seag4_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=6,serial=$d_Seag5_ser value=$d_Seag5_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=7,serial=$d_Seag6_ser value=$d_Seag6_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=8,serial=$d_Seag7_ser value=$d_Seag7_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=9,serial=$d_Seag8_ser value=$d_Seag8_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=10,serial=$d_king_ser value=$d_king_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_temp,disk_number=11,serial=$d_sams_ser value=$d_sams_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=cpu_temp,cpu_number=0 value=$cpu0_temp"
	curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=cpu_temp,cpu_number=1 value=$cpu1_temp"	
	
	#Wait for a bit before checking again
	sleep "$sleeptime"
	
done
