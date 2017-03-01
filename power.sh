#!/bin/bash
power1=$(ssh mfi@192.168.77.100 -C '/bin/cat /proc/analog/rms2')
curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "power_stats,sensor=mains,type=current value=$power1"
#echo $power
