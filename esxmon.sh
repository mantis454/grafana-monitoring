#!/bin/bash

#This script gets the current memory and CPU usage for the
#main ESXi server.  It's hacky at best but it works.

#The time we are going to sleep between readings
sleeptime=60

#Prepare to start the loop and warn the user
echo "Press [CTRL+C] to stop..."
while :
do

    #Let's start with the "easy" one, get the CPU usage
    cpu1=`snmpget -v 2c -c public 192.168.77.175 HOST-RESOURCES-MIB::hrProcessorLoad.1 -Ov`
    cpu2=`snmpget -v 2c -c public 192.168.77.175 HOST-RESOURCES-MIB::hrProcessorLoad.2 -Ov`
    cpu3=`snmpget -v 2c -c public 192.168.77.175 HOST-RESOURCES-MIB::hrProcessorLoad.3 -Ov`
    cpu4=`snmpget -v 2c -c public 192.168.77.175 HOST-RESOURCES-MIB::hrProcessorLoad.4 -Ov`
    cpu5=`snmpget -v 2c -c public 192.168.77.175 HOST-RESOURCES-MIB::hrProcessorLoad.5 -Ov`
    cpu6=`snmpget -v 2c -c public 192.168.77.175 HOST-RESOURCES-MIB::hrProcessorLoad.6 -Ov`
    cpu7=`snmpget -v 2c -c public 192.168.77.175 HOST-RESOURCES-MIB::hrProcessorLoad.7 -Ov`
    cpu8=`snmpget -v 2c -c public 192.168.77.175 HOST-RESOURCES-MIB::hrProcessorLoad.8 -Ov`
#    cpu21=`snmpget -v 2c -c public 192.168.77.176 HOST-RESOURCES-MIB::hrProcessorLoad.1 -Ov`
#    cpu22=`snmpget -v 2c -c public 192.168.77.176 HOST-RESOURCES-MIB::hrProcessorLoad.2 -Ov`
#    cpu23=`snmpget -v 2c -c public 192.168.77.176 HOST-RESOURCES-MIB::hrProcessorLoad.3 -Ov`
#    cpu24=`snmpget -v 2c -c public 192.168.77.176 HOST-RESOURCES-MIB::hrProcessorLoad.4 -Ov`
#   uptime=`snmpget -v 2c -c public 192.168.77.175 SNMPv2-MIB::sysUpTime.0 -Ov`
    cpu9=`snmpget -v 2c -c public 192.168.77.75 HOST-RESOURCES-MIB::hrProcessorLoad.196608 -Ov`
    cpu10=`snmpget -v 2c -c public 192.168.77.75 HOST-RESOURCES-MIB::hrProcessorLoad.196609 -Ov`
    #VMware disk usage
    data1=`snmpget -v 2c -c public 192.168.77.175 HOST-RESOURCES-MIB::hrStorageUsed.4 -Ov`
    data2=`snmpget -v 2c -c public 192.168.77.175 HOST-RESOURCES-MIB::hrStorageUsed.6 -Ov`
    #Freenas Disk space
    pool1=`snmpget -v 2c -c public 192.168.77.75 .1.3.6.1.4.1.25359.1.1.12.0 -Ov`
    pool2=`snmpget -v 2c -c public 192.168.77.75 .1.3.6.1.4.1.25359.1.1.12.3 -Ov`
    pool5=`snmpget -v 2c -c public 192.168.77.75 .1.3.6.1.4.1.25359.1.1.12.4 -Ov`
    pool1a=`snmpget -v 2c -c public 192.168.77.75 .1.3.6.1.4.1.25359.1.1.13.0 -Ov`
    pool2a=`snmpget -v 2c -c public 192.168.77.75 .1.3.6.1.4.1.25359.1.1.13.3 -Ov`
    pool5a=`snmpget -v 2c -c public 192.168.77.75 .1.3.6.1.4.1.25359.1.1.13.4 -Ov`
    #Mikrotik temperature
    switch1=`snmpget -v 2c -c public 192.168.77.99 .1.3.6.1.4.1.14988.1.1.3.10.0 -Ov`

    #Strip out the value from the SNMP query
    cpu1=$(echo $cpu1 | cut -c 10-)
    cpu2=$(echo $cpu2 | cut -c 10-)
    cpu3=$(echo $cpu3 | cut -c 10-)
    cpu4=$(echo $cpu4 | cut -c 10-)
    cpu5=$(echo $cpu5 | cut -c 10-)
    cpu6=$(echo $cpu6 | cut -c 10-)
    cpu7=$(echo $cpu7 | cut -c 10-)
    cpu8=$(echo $cpu8 | cut -c 10-)
    cpu9=$(echo $cpu9 | cut -c 10-)
    cpu10=$(echo $cpu10 | cut -c 10-)
#    cpu21=$(echo $cpu21 | cut -c 10-)
#    cpu22=$(echo $cpu22 | cut -c 10-)
#    cpu23=$(echo $cpu23 | cut -c 10-)
#    cpu24=$(echo $cpu24 | cut -c 10-)
 #  uptime=$(echo $uptime | awk '{print $2}' | grep -o '[0-9]\+')
    pool1=$(echo $pool1 | cut -c 10-)
    pool2=$(echo $pool2 | cut -c 10-)
    pool5=$(echo $pool5 | cut -c 10-)
    pool1a=$(echo $pool1a | cut -c 10-)
    pool2a=$(echo $pool2a | cut -c 10-)
    pool5a=$(echo $pool5a | cut -c 10-)
    data11=$(echo $data1 | cut -c 10-)
    data12=$(echo $data2 | cut -c 10-)
    data1=$((457728 - data11))
    data2=$((511744 - data12))
    switch1=$(echo $switch1 | cut -c 10-)
    cpu99=$(((cpu1+cpu2+cpu3+cpu4+cpu5+cpu6+cpu7+cpu8) / 8))

    #Not get power from Mfi sensor
#    power1=$(ssh mfi@192.168.77.100 -C '/bin/cat /proc/analog/rms2')

    #Now lets get the hardware info from the remote host
    hwinfo=$(ssh -t 192.168.77.175 "esxcfg-info --hardware")

    #Lets try to find the lines we are looking for
    while read -r line; do
        #Check if we have the line we are looking for
        if [[ $line == *"Kernel Memory"* ]]
        then
          kmemline=$line
        fi
        if [[ $line == *"-Free."* ]]
        then
          freememline=$line
        fi
        #echo "... $line ..."
    done <<< "$hwinfo"

    #Remove the long string of .s
    kmemline=$(echo $kmemline | tr -s '[.]')
    freememline=$(echo $freememline | tr -s '[.]')

    #Lets parse out the memory values from the strings
    #First split on the only remaining . in the strings
    IFS='.' read -ra kmemarr <<< "$kmemline"
    kmem=${kmemarr[1]}
    IFS='.' read -ra freememarr <<< "$freememline"
    freemem=${freememarr[1]}
    #Now break it apart on the space
    IFS=' ' read -ra kmemarr <<< "$kmem"
    kmem=${kmemarr[0]}
    IFS=' ' read -ra freememarr <<< "$freemem"
    freemem=${freememarr[0]}

    #Now we can finally calculate used percentage
    used=$((kmem - freemem))
    used=$((used * 100))
    pcent=$((used / kmem))


    
#    echo "CPU1: $cpu1%"
#    echo "CPU2: $cpu2%"
#    echo "CPU3: $cpu3%"
#    echo "CPU4: $cpu4%"
#    echo "CPU5: $cpu5%"
#    echo "CPU6: $cpu6%"
#    echo "CPU7: $cpu7%"
#    echo "CPU8: $cpu8%"
#    echo "Memory Used: $pcent%"
#    echo "Uptime: $uptime"
    
    #Write the data to the database
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi1,type=cpu_usage,cpu_number=1 value=$cpu1"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi1,type=cpu_usage,cpu_number=2 value=$cpu2"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi1,type=cpu_usage,cpu_number=3 value=$cpu3"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi1,type=cpu_usage,cpu_number=4 value=$cpu4"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi1,type=cpu_usage,cpu_number=5 value=$cpu5"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi1,type=cpu_usage,cpu_number=6 value=$cpu6"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi1,type=cpu_usage,cpu_number=7 value=$cpu7"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi1,type=cpu_usage,cpu_number=8 value=$cpu8"
#    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi2,type=cpu_usage,cpu_number=1 value=$cpu21"
#    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi2,type=cpu_usage,cpu_number=2 value=$cpu22"
#    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi2,type=cpu_usage,cpu_number=3 value=$cpu23"
#    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi2,type=cpu_usage,cpu_number=4 value=$cpu24"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi1,type=cpu_usage,cpu_number=99 value=$cpu99"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi1,type=memory_usage value=$pcent"
#    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi2,type=memory_usage value=$pcent1"
#   curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi1,type=uptime value=$uptime"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=esxi1,type=cpu_usage,cpu_number=9 value=$cpu9"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=esxi1,type=cpu_usage,cpu_number=10 value=$cpu10"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_space,pool_num=1 value=$pool1"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_space,pool_num=2 value=$pool2"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_space,pool_num=5 value=$pool5"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_space,pool_num=6 value=$pool1a"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_space,pool_num=7 value=$pool2a"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "freenas_stats,host=freenas,type=disk_space,pool_num=8 value=$pool5a"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi1,type=disk_usage,datastore=1 value=$data1"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "esxi_stats,host=esxi1,type=disk_usage,datastore=2 value=$data2"
    curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "switch_stats,switch=mikrotik,type=temperature value=$switch1"
#   curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "power_stats,sensor=mains,type=current value=$power1"
#Wait for a bit before checking again
    sleep "$sleeptime"
    
done
