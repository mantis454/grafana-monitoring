#!/bin/bash
ubntpower=$(ssh ubnt@192.168.77.100 -C '/bin/cat /proc/analog/rms1;/bin/cat /proc/analog/rms2')

for var in line1 line2; do
  IFS= read -r "$var" || break
done <<< "$ubntpower"

#echo $line1
curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "power_stats,sensor=mains,type=current value=$line2"
curl -i -XPOST 'http://localhost:8086/write?db=home' --data-binary "power_stats,sensor=hwater,type=current value=$line1"
